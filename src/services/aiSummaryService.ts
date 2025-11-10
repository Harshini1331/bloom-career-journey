// AI Summary Service - Generates reflective summaries using Gemini API

import { SummaryQuestions } from '@/types/assessmentSummary';
import { supabase } from '@/integrations/supabase/client';

interface VideoResponse {
  videoId: string;
  videoTitle: string;
  responses: {
    question1?: string;
    question2?: string;
    question3?: string;
    question4?: string;
    [key: string]: string | undefined;
  };
}

interface AssessmentResponses {
  [videoKey: string]: VideoResponse | any;
}

interface GenerateSummaryResult {
  success: boolean;
  summary?: SummaryQuestions;
  error?: string;
}

interface SummaryTemplate {
  en: {
    question1: string;
    question2: string;
    question3?: string; // Optional for assessments with only 2 questions
    question4?: string; // Optional for assessments with 4 questions (Dreams)
    question5?: string; // Optional for assessments with 6 questions (School Learning)
    question6?: string; // Optional for assessments with 6 questions (School Learning)
    question7?: string; // Optional for Hobbies assessment (talents)
    question8?: string; // Optional for Hobbies assessment (talents)
    question9?: string; // Optional for Hobbies assessment (talents)
    question10?: string; // Optional for Hobbies assessment (talents)
    [key: string]: string | undefined; // Allow any additional question keys
  };
  kn: {
    question1: string;
    question2: string;
    question3?: string; // Optional for assessments with only 2 questions
    question4?: string; // Optional for assessments with 4 questions (Dreams)
    question5?: string; // Optional for assessments with 6 questions (School Learning)
    question6?: string; // Optional for assessments with 6 questions (School Learning)
    question7?: string; // Optional for Hobbies assessment (talents)
    question8?: string; // Optional for Hobbies assessment (talents)
    question9?: string; // Optional for Hobbies assessment (talents)
    question10?: string; // Optional for Hobbies assessment (talents)
    [key: string]: string | undefined; // Allow any additional question keys
  };
}

class AISummaryService {
  private apiKey: string | undefined;
  private endpoint: string;
  private fallbackEndpoint: string;
  private templateCache: Map<string, SummaryTemplate> = new Map();

  constructor() {
    this.apiKey = import.meta.env.VITE_GEMINI_API_KEY;
    // Use Gemini 2.0 Flash (confirmed available in your API key metrics)
    this.endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent';
    // Fallback to experimental model if needed
    this.fallbackEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-exp-1206:generateContent';
  }

  /**
   * Check if Gemini API is configured
   */
  isConfigured(): boolean {
    return !!this.apiKey && this.apiKey.trim().length > 0;
  }

  /**
   * Detect if text contains Kannada script (Unicode range: 0C80-0CFF)
   */
  private containsKannada(text: string): boolean {
    if (!text) return false;
    // Kannada Unicode range: 0C80-0CFF
    return /[\u0C80-\u0CFF]/.test(text);
  }

  /**
   * Detect if student responses are primarily in Kannada
   */
  private detectLanguage(responses: AssessmentResponses): 'en' | 'kn' {
    let kannadaCount = 0;
    let totalCount = 0;
    
    Object.keys(responses).forEach((key) => {
      const videoData = responses[key];
      
      if (videoData && typeof videoData === 'object') {
        const videoResponses = videoData.responses || videoData;
        
        Object.keys(videoResponses).forEach((qKey) => {
          const answer = videoResponses[qKey];
          if (answer && typeof answer === 'string' && answer.trim()) {
            totalCount++;
            if (this.containsKannada(answer)) {
              kannadaCount++;
            }
          }
        });
      }
    });
    
    // If more than 50% of responses contain Kannada, consider it Kannada
    return totalCount > 0 && kannadaCount / totalCount > 0.5 ? 'kn' : 'en';
  }

  /**
   * Format student responses for the AI prompt
   */
  private formatResponses(responses: AssessmentResponses): string {
    let formatted = '';
    
    Object.keys(responses).forEach((key) => {
      const videoData = responses[key];
      
      // Handle different response structures
      if (videoData && typeof videoData === 'object') {
        const videoTitle = videoData.videoTitle || videoData.title || key;
        formatted += `\n=== ${videoTitle} ===\n`;
        
        const videoResponses = videoData.responses || videoData;
        
        Object.keys(videoResponses).forEach((qKey) => {
          const answer = videoResponses[qKey];
          if (answer && typeof answer === 'string' && answer.trim()) {
            formatted += `${qKey}: ${answer}\n`;
          }
        });
      }
    });
    
    return formatted || 'No responses available';
  }

  /**
   * Fetch summary template from database
   */
  private async getSummaryTemplate(assessmentType: string = 'inspiration'): Promise<SummaryTemplate | null> {
    // Check cache first
    if (this.templateCache.has(assessmentType)) {
      return this.templateCache.get(assessmentType)!;
    }

    try {
      const { data, error } = await supabase.rpc('get_summary_template', {
        p_assessment_type: assessmentType
      });

      if (error) {
        console.error('Error fetching summary template:', error);
        return null;
      }

      if (!data || data.length === 0) {
        console.warn(`No summary template found for assessment type: ${assessmentType}`);
        return null;
      }

      const template = data[0].summary_questions as SummaryTemplate;
      
      // Cache the template
      this.templateCache.set(assessmentType, template);
      
      return template;
    } catch (error) {
      console.error('Exception fetching summary template:', error);
      return null;
    }
  }

  /**
   * Build the prompt for Gemini API
   */
  private async buildPrompt(responses: AssessmentResponses, language: 'en' | 'kn' = 'en'): Promise<string> {
    const formattedResponses = this.formatResponses(responses);
    
    // Fetch template from database
    const template = await this.getSummaryTemplate('inspiration');
    
    if (!template) {
      console.error('Failed to fetch summary template, falling back to default');
      // Fallback to a basic prompt if database fetch fails
      return this.buildFallbackPrompt(responses, language);
    }

    const isKannada = language === 'kn';
    const langKey = isKannada ? 'kn' : 'en';
    
    const languageInstruction = isKannada 
      ? '\n\nIMPORTANT LANGUAGE REQUIREMENT:\n- The student\'s responses are in Kannada (ಕನ್ನಡ).\n- You MUST generate your summary answers in Kannada (ಕನ್ನಡ) script.\n- Write all three answers in Kannada, maintaining the student\'s natural voice.\n- Use Kannada script for all text in question1, question2, and question3.\n'
      : '';
    
    // Get questions from database template
    const questions = template[langKey];
    
    // Instructions remain hardcoded in the service
    const instructions = isKannada
      ? {
          question1: "- ವೀಡಿಯೊಗಳಿಂದ ನಿರ್ದಿಷ್ಟ ಕ್ಷಣಗಳು, ಉಲ್ಲೇಖಗಳು ಅಥವಾ ವಿಷಯಗಳನ್ನು ಗುರುತಿಸಿ\n- ವಿದ್ಯಾರ್ಥಿ ಉಲ್ಲೇಖಿಸಿದ ವೈಯಕ್ತಿಕ ಅನುಭವಗಳಿಗೆ ಸಂಪರ್ಕಿಸಿ\n- 3-5 ಪ್ರಮುಖ ತೆಗೆದುಕೊಳ್ಳುವಿಕೆಗಳೊಂದಿಗೆ ನಿರ್ದಿಷ್ಟವಾಗಿರಿ\n- ಮೊದಲ ವ್ಯಕ್ತಿಯಲ್ಲಿ ಬರೆಯಿರಿ (\"ನಾನು ... ಮೂಲಕ ಪ್ರೇರೇಪಿಸಲ್ಪಟ್ಟೆನು\")",
          question2: "- ವೀಡಿಯೊಗಳಲ್ಲಿ ಉಲ್ಲೇಖಿಸಲಾದ ನಕಾರಾತ್ಮಕ ಮಾದರಿಗಳು, ಅಭ್ಯಾಸಗಳು ಅಥವಾ ಮನೋಭಾವಗಳನ್ನು ಗುರುತಿಸಿ\n- ಇವುಗಳನ್ನು ಏಕೆ ತಪ್ಪಿಸಬೇಕು ಎಂಬುದನ್ನು ವಿವರಿಸಿ\n- ರಚನಾತ್ಮಕ ಚೌಕಟ್ಟನ್ನು ಒದಗಿಸಿ\n- ಮೊದಲ ವ್ಯಕ್ತಿಯಲ್ಲಿ ಬರೆಯಿರಿ (\"ನಾನು ... ತಪ್ಪಿಸಬೇಕು\")",
          question3: "- ಸಾಮಾನ್ಯ ವಿಷಯಗಳು, ಮೌಲ್ಯಗಳು ಅಥವಾ ಗುಣಲಕ್ಷಣಗಳನ್ನು ಹುಡುಕಿ\n- ವೀಡಿಯೊ ಪಾತ್ರಗಳನ್ನು ವಿದ್ಯಾರ್ಥಿ ಉಲ್ಲೇಖಿಸಿದ ನಿಜ ಜೀವನದ ಮಾದರಿಗಳಿಗೆ ಸಂಪರ್ಕಿಸಿ\n- ಯಾರನ್ನಾದರೂ ಪ್ರೇರೇಪಿಸುವ ಮಾದರಿಗಳನ್ನು ಗುರುತಿಸಿ\n- ಮೊದಲ ವ್ಯಕ್ತಿಯಲ್ಲಿ ಬರೆಯಿರಿ (\"ನಾನು ಗಮನಿಸಿದ್ದೇನೆ ...\")"
        }
      : {
          question1: "- Identify specific moments, quotes, or themes from the videos\n- Connect to any personal experiences the student mentioned\n- Be specific with 3-5 key takeaways\n- Write in first person (\"I was inspired by...\")",
          question2: "- Identify negative patterns, habits, or attitudes mentioned in the videos\n- Explain why these should be avoided\n- Provide constructive framing\n- Write in first person (\"I should avoid...\")",
          question3: "- Find common themes, values, or traits\n- Connect video characters to real-life role models the student mentioned\n- Identify patterns of what makes someone inspiring\n- Write in first person (\"I notice that...\")"
        };
    
    const questionsPrompt = `Question 1: ${questions.question1}
${instructions.question1}

Question 2: ${questions.question2}
${instructions.question2}

Question 3: ${questions.question3}
${instructions.question3}`;
    
    return `You are helping a student in grade 8 or 9 from a rural area in India. They watched some videos and answered questions about them.
Based on what the student wrote below, write a simple summary in easy words.
${languageInstruction}
STUDENT ANSWERS ABOUT THE VIDEOS:
${formattedResponses}

Write answers to these 3 questions as if the student is speaking (use "I" and "me").

${questionsPrompt}

IMPORTANT RULES:
- Write like the student is talking (use "I" and "me")
- Use very simple words that a grade 8 or 9 student can easily understand
- Use plain English - no difficult words
- For Question 1, produce the Markdown table described above so each category appears on its own row
- The TOTAL length should be 100-150 words for all three answers together
- Be short and clear
- Use the student's own words from their answers
- Write like the student himself/herself is writing
- Format the response as valid JSON with this exact structure:

{
  "question1": "Your answer here...",
  "question2": "Your answer here...",
  "question3": "Your answer here..."
}

Return ONLY the JSON object, no additional text or markdown formatting.`;
  }

  /**
   * Fallback prompt builder in case database fetch fails
   */
  private buildFallbackPrompt(responses: AssessmentResponses, language: 'en' | 'kn' = 'en'): string {
    const formattedResponses = this.formatResponses(responses);
    const isKannada = language === 'kn';
    const languageInstruction = isKannada 
      ? '\n\nIMPORTANT LANGUAGE REQUIREMENT:\n- The student\'s responses are in Kannada (ಕನ್ನಡ).\n- You MUST generate your summary answers in Kannada (ಕನ್ನಡ) script.\n- Write all three answers in Kannada, maintaining the student\'s natural voice.\n- Use Kannada script for all text in question1, question2, and question3.\n'
      : '';
    
    const questionsPrompt = isKannada
      ? `Question 1: ಈ ವೀಡಿಯೊಗಳಿಂದ ಮತ್ತು ನಿಮ್ಮ ಸ್ವಂತ ಅನುಭವಗಳಿಂದ ನಿಮ್ಮನ್ನು ಪ್ರೇರೇಪಿಸಿದ ವಿಷಯಗಳನ್ನು ಪಟ್ಟಿ ಮಾಡಿ.

Question 2: ಈ ಎಲ್ಲಾ ವೀಡಿಯೊಗಳನ್ನು ನೋಡಿದ ನಂತರ, ನೀವು ತಪ್ಪಿಸಬೇಕಾದ ನಡವಳಿಕೆಗಳು ಯಾವುವು? ಅವುಗಳನ್ನು ಬರೆಯಿರಿ.

Question 3: ನಿಮ್ಮನ್ನು ಪ್ರೇರೇಪಿಸಿದ ಈ ವೀಡಿಯೊಗಳಲ್ಲಿನ ಪಾತ್ರಗಳು ಮತ್ತು ನಿಜ ಜೀವನದಲ್ಲಿ ನಿಮ್ಮನ್ನು ಪ್ರೇರೇಪಿಸಿದ ಜನರ ನಡುವಿನ ಹೋಲಿಕೆಗಳನ್ನು ನಿಮ್ಮ ಸ್ನೇಹಿತರೊಂದಿಗೆ ಚರ್ಚಿಸಿ. ನಂತರ ಒಂದು ಸಾರಾಂಶ ಬರೆಯಿರಿ.`
      : `Question 1: List the things that inspired you from these videos and from your own experiences.

Question 2: After watching all these videos, which behaviors do you feel you should avoid? Write them down.

Question 3: Discuss the similarities between the characters in these videos who inspired you, and the people who have inspired you in real life, with your friends. Then write a summary.`;
    
    return `You are helping a student in grade 8 or 9 from a rural area in India. They watched some videos and answered questions about them.
Based on what the student wrote below, write a simple summary in easy words.
${languageInstruction}
STUDENT ANSWERS ABOUT THE VIDEOS:
${formattedResponses}

Write answers to these 3 questions as if the student is speaking (use "I" and "me").

${questionsPrompt}

IMPORTANT RULES:
- Write like the student is talking (use "I" and "me")
- Use very simple words that a grade 8 or 9 student can easily understand
- Use plain English - no difficult words
- The TOTAL length should be 100-150 words for all three answers together
- Be short and clear
- Use the student's own words from their answers
- Write like the student himself/herself is writing
- Format the response as valid JSON with this exact structure:

{
  "question1": "Your answer here...",
  "question2": "Your answer here...",
  "question3": "Your answer here..."
}

Return ONLY the JSON object, no additional text or markdown formatting.`;
  }

  /**
   * Parse Gemini API response to extract JSON
   */
  private parseGeminiResponse(responseText: string): SummaryQuestions | null {
    try {
      // Remove markdown code blocks if present
      let cleanedText = responseText.trim();
      
      // Remove ```json and ``` markers
      cleanedText = cleanedText.replace(/^```json\s*/i, '');
      cleanedText = cleanedText.replace(/^```\s*/i, '');
      cleanedText = cleanedText.replace(/\s*```$/i, '');
      cleanedText = cleanedText.trim();
      
      // Parse JSON
      const parsed = JSON.parse(cleanedText);
      
      console.log('📋 Parsed JSON structure:', Object.keys(parsed));
      
      // Handle dream portfolio structure
      if (Array.isArray(parsed.entries)) {
        const entries = parsed.entries.map((entry: any) => ({
          dream: (entry?.dream ?? '').trim(),
          quality_value_strength: (entry?.quality_value_strength ?? '').trim(),
          prevent_failure: (entry?.prevent_failure ?? '').trim(),
          study_path: (entry?.study_path ?? '').trim()
        }));

        return {
          question1: JSON.stringify(entries),
          question2: parsed.question2 || parsed.summary || '',
          question3: parsed.question3 || parsed.action_plan || '',
          question4: '',
          question5: '',
          question6: ''
        };
      }

      // Handle Role Models assessment (only question1)
      if (parsed.question1 && !parsed.question2) {
        console.log('✅ Role Models format detected (question1 only)');
        return {
          question1: parsed.question1,
          question2: '',
          question3: '',
          question4: '',
          question5: '',
          question6: ''
        };
      }

      // Validate structure - support 2, 3, 4, and 6 question formats
      if (parsed.question1 && parsed.question2) {
        return {
          question1: parsed.question1,
          question2: parsed.question2,
          question3: parsed.question3 || '', // Optional third question
          question4: parsed.question4 || '', // Optional fourth question (Dreams)
          question5: parsed.question5 || '', // Optional fifth question (School Learning)
          question6: parsed.question6 || '' // Optional sixth question (School Learning)
        };
      }
      
      console.error('❌ Invalid JSON structure - missing question1 or question2:', parsed);
      return null;
    } catch (error) {
      console.error('❌ Failed to parse Gemini response:', error);
      console.error('📄 Raw response text (first 500 chars):', responseText.substring(0, 500));
      return null;
    }
  }

  /**
   * Generate AI summary for inspiration assessment
   */
  async generateInspirationSummary(
    responses: AssessmentResponses
  ): Promise<GenerateSummaryResult> {
    if (!this.isConfigured()) {
      return {
        success: false,
        error: 'Gemini API key is not configured'
      };
    }

    // Validate responses
    if (!responses || Object.keys(responses).length === 0) {
      return {
        success: false,
        error: 'No responses provided'
      };
    }

    try {
      // Detect language from student responses
      const detectedLanguage = this.detectLanguage(responses);
      console.log(`🌐 Detected language from student responses: ${detectedLanguage}`);
      
      const prompt = await this.buildPrompt(responses, detectedLanguage);
      
      // Use exact same format as chatbot - no generationConfig initially
      const requestBody = {
        contents: [
          {
            parts: [
              { text: prompt }
            ]
          }
        ]
      };

      console.log('📡 Calling Gemini API:', this.endpoint);
      console.log('🔑 API Key configured:', !!this.apiKey);
      console.log('📝 Request body:', JSON.stringify(requestBody));

      // Try primary endpoint (gemini-1.5-flash-latest)
      let response = await fetch(`${this.endpoint}?key=${this.apiKey}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody)
      });

      // If 404, try fallback endpoint (gemini-1.5-pro-latest)
      if (!response.ok && response.status === 404) {
        console.warn('⚠️ Primary model not found, trying fallback:', this.fallbackEndpoint);
        
        response = await fetch(`${this.fallbackEndpoint}?key=${this.apiKey}`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(requestBody)
        });
      }

      if (!response.ok) {
        const errorData = await response.text();
        console.error('❌ Gemini API error (Full Response):', errorData);
        console.error('❌ Status:', response.status);
        console.error('❌ Status Text:', response.statusText);
        console.error('❌ Response Headers:', Object.fromEntries(response.headers.entries()));
        
        // Try to parse error for more details
        try {
          const errorJson = JSON.parse(errorData);
          console.error('❌ Parsed Error:', JSON.stringify(errorJson, null, 2));
          
          // Log suggested models if available
          if (errorJson.error?.message) {
            console.error('❌ Error Message:', errorJson.error.message);
          }
        } catch (e) {
          console.error('❌ Could not parse error as JSON');
        }
        
        return {
          success: false,
          error: `API request failed: ${response.status} - ${response.statusText}`
        };
      }

      const data = await response.json();
      console.log('✅ Gemini API response received');
      console.log('📊 Response structure:', {
        hasCandidates: !!data?.candidates,
        candidatesCount: data?.candidates?.length || 0,
        hasContent: !!data?.candidates?.[0]?.content
      });

      const generatedText = data?.candidates?.[0]?.content?.parts?.[0]?.text;

      if (!generatedText) {
        console.error('❌ No text in response:', JSON.stringify(data, null, 2));
        return {
          success: false,
          error: 'No content generated by AI'
        };
      }

      console.log('✅ Successfully generated summary, length:', generatedText.length);

      const summary = this.parseGeminiResponse(generatedText);

      if (!summary) {
        return {
          success: false,
          error: 'Failed to parse AI response'
        };
      }

      return {
        success: true,
        summary
      };

    } catch (error) {
      console.error('Error generating summary:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred'
      };
    }
  }

  /**
   * Validate summary content
   */
  validateSummary(summary: SummaryQuestions): boolean {
    const minLength = 50; // Minimum characters per answer
    
    return !!(
      summary.question1 && summary.question1.length >= minLength &&
      summary.question2 && summary.question2.length >= minLength &&
      summary.question3 && summary.question3.length >= minLength
    );
  }

  /**
   * Get word count for a summary
   */
  getSummaryWordCount(summary: SummaryQuestions): number {
    const allText = `${summary.question1} ${summary.question2} ${summary.question3}`;
    return allText.split(/\s+/).filter(word => word.length > 0).length;
  }

  /**
   * Format Dreams assessment responses for summary
   */
  private formatDreamsResponses(responses: Record<string, string>): string {
    let formatted = '=== MY DREAMS ASSESSMENT ===\n';
    
    Object.entries(responses).forEach(([key, value]) => {
      if (value && typeof value === 'string' && value.trim()) {
        formatted += `${key}: ${value}\n`;
      }
    });
    
    return formatted || 'No responses available';
  }

  /**
   * Build prompt for Dreams assessment summary
   */
  private async buildDreamsPrompt(
    responses: Record<string, string>,
    language: 'en' | 'kn' = 'en'
  ): Promise<string> {
    const formattedResponses = this.formatDreamsResponses(responses);

    // Fetch template from database
    const template = await this.getSummaryTemplate('dreams');

    if (!template) {
      console.error('Failed to fetch Dreams summary template, falling back to default');
      return this.buildDreamsFallbackPrompt(responses, language);
    }

    const isKannada = language === 'kn';
    const langKey = isKannada ? 'kn' : 'en';

    const languageInstruction = isKannada
      ? '\n\nIMPORTANT LANGUAGE REQUIREMENT:\n- The student\'s responses are in Kannada (ಕನ್ನಡ).\n- You MUST generate your summary answers in Kannada (ಕನ್ನಡ) script.\n- Write all entries in Kannada, maintaining the student\'s natural voice.\n'
      : '';

    // Get questions from database template
    const questions = template[langKey];

    // Instructions for generating portfolio
    const instructions = isKannada
      ? '- ಪ್ರತಿಯೊಂದು ಕನಸಿಗಾಗಿ, ನಿಮ್ಮ ಪ್ರತಿಕ್ರಿಯೆಗಳಿಂದ ನಿಜವಾದ ವಿವರಗಳನ್ನು ಬಳಸಿ\n- ವಿದ್ಯಾರ್ಥಿಯ ಧ್ವನಿಯಲ್ಲಿ ಬರೆಯಿರಿ (ಮೊದಲ ವ್ಯಕ್ತಿ)\n- ಪ್ರತಿಯೊಂದು ಪ್ರವೇಶಕ್ಕೆ ಸ್ಪಷ್ಟವಾಗಿ ಮತ್ತು ಸಂಕ್ಷಿಪ್ತವಾಗಿ ಉತ್ತರಿಸಿ'
      : '- For each dream, use specific details from their responses\n- Write in the student\'s voice (first person)\n- Be clear and concise for each entry';

    const questionsPrompt = `Create a dream portfolio with 3 dream entries. For each entry, fill in:

Entry Column 1: ${questions.question1}
Entry Column 2: ${questions.question2}
Entry Column 3: ${questions.question3}
Entry Column 4: ${questions.question4}

${instructions}`;

    return `You are helping a student in grade 8 or 9 from a rural area in India. They wrote about their dreams.
Based on what the student wrote below, write a simple summary in easy words.
${languageInstruction}
STUDENT ANSWERS ABOUT THEIR DREAMS:
${formattedResponses}

Write exactly 3 dream entries as if the student is speaking (use "I" and "me").

${questionsPrompt}

IMPORTANT RULES:
- Write exactly 3 dream entries
- Each entry should have 4 parts as shown above
- Write like the student is talking (use "I" and "me")
- Use very simple words that a grade 8 or 9 student can easily understand
- Use plain English - no difficult words
- The TOTAL length should be 100-150 words for all 3 entries together
- Be short and clear
- Use the student's own words from their answers
- Write like the student himself/herself is writing
- Format the response as valid JSON with this exact structure:

{
  "entries": [
    {
      "dream": "Dream description here",
      "quality_value_strength": "Qualities/values/strengths that help achieve this dream",
      "prevent_failure": "Actions to prevent this dream from failing",
      "study_path": "What to study after 10th to achieve this dream (if applicable)"
    },
    {
      "dream": "Second dream description",
      "quality_value_strength": "...",
      "prevent_failure": "...",
      "study_path": "..."
    },
    {
      "dream": "Third dream description",
      "quality_value_strength": "...",
      "prevent_failure": "...",
      "study_path": "..."
    }
  ]
}

Return ONLY the JSON object, no additional text or markdown formatting.`;
  }

  /**
   * Fallback prompt for Dreams if database fetch fails
   */
  private buildDreamsFallbackPrompt(
    responses: Record<string, string>,
    language: 'en' | 'kn' = 'en'
  ): string {
    const formattedResponses = this.formatDreamsResponses(responses);
    const isKannada = language === 'kn';
    const languageInstruction = isKannada
      ? '\n\nIMPORTANT LANGUAGE REQUIREMENT:\n- The student\'s responses are in Kannada (ಕನ್ನಡ).\n- You MUST generate your summary answers in Kannada (ಕನ್ನಡ) script.\n- Write all entries in Kannada, maintaining the student\'s natural voice.\n'
      : '';

    const questionsPrompt = isKannada
      ? `Create a dream portfolio with 3 dream entries. For each entry, fill in:

Entry Column 1: ಕನಸು
Entry Column 2: ನಿಮ್ಮ ಕನಸನ್ನು ಸಾಧಿಸಲು ನಿಮಗೆ ಸಹಾಯ ಮಾಡುವ ಯಾವ ಗುಣ, ಮೌಲ್ಯ, ಶಕ್ತಿ
Entry Column 3: ಕನಸು ವಿಫಲವಾಗದಂತೆ ಮಾಡಲು ನೀವು ಏನು ಮಾಡಬೇಕು
Entry Column 4: ಈ ಕನಸನ್ನು ಸಾಧಿಸಲು ನೀವು 10 ನೇ ತರಗತಿಯ ನಂತರ ಏನು ಅಧ್ಯಯನ ಮಾಡಬೇಕು (ಬೇಕಿದ್ದರೆ)`
      : `Create a dream portfolio with 3 dream entries. For each entry, fill in:

Entry Column 1: Dream
Entry Column 2: Which quality, value, strength will help you achieve your dream
Entry Column 3: What you will have to do to ensure that the dream doesn't fail
Entry Column 4: What should you study after 10th to achieve this dream (if applicable)`;

    return `You are helping a student in grade 8 or 9 from a rural area in India. They wrote about their dreams.
Based on what the student wrote below, write a simple summary in easy words.
${languageInstruction}
STUDENT ANSWERS ABOUT THEIR DREAMS:
${formattedResponses}

Write exactly 3 dream entries as if the student is speaking (use "I" and "me").

${questionsPrompt}

IMPORTANT RULES:
- Write exactly 3 dream entries
- Each entry should have 4 parts as shown above
- Write like the student is talking (use "I" and "me")
- Use very simple words that a grade 8 or 9 student can easily understand
- Use plain English - no difficult words
- The TOTAL length should be 100-150 words for all 3 entries together
- Be short and clear
- Use the student's own words from their answers
- Write like the student himself/herself is writing
- Format the response as valid JSON with this exact structure:

{
  "entries": [
    {
      "dream": "Dream description here",
      "quality_value_strength": "Qualities/values/strengths that help achieve this dream",
      "prevent_failure": "Actions to prevent this dream from failing",
      "study_path": "What to study after 10th to achieve this dream (if applicable)"
    },
    {
      "dream": "Second dream description",
      "quality_value_strength": "...",
      "prevent_failure": "...",
      "study_path": "..."
    },
    {
      "dream": "Third dream description",
      "quality_value_strength": "...",
      "prevent_failure": "...",
      "study_path": "..."
    }
  ]
}

Return ONLY the JSON object, no additional text or markdown formatting.`;
  }

  /**
   * Generate AI summary for Dreams assessment
   */
  async generateDreamsSummary(
    responses: Record<string, string>
  ): Promise<GenerateSummaryResult> {
    if (!this.isConfigured()) {
      return {
        success: false,
        error: 'Gemini API key is not configured'
      };
    }

    // Validate responses
    if (!responses || Object.keys(responses).length === 0) {
      return {
        success: false,
        error: 'No responses provided from Dreams assessment'
      };
    }

    try {
      // Detect language from student responses
      const detectedLanguage = this.detectLanguage({ part1: responses });
      console.log(`🌐 Detected language from student responses: ${detectedLanguage}`);

      const prompt = await this.buildDreamsPrompt(responses, detectedLanguage);

      const requestBody = {
        contents: [
          {
            parts: [
              { text: prompt }
            ]
          }
        ]
      };

      console.log('📡 Calling Gemini API for Dreams summary:', this.endpoint);

      // Try primary endpoint
      let response = await fetch(`${this.endpoint}?key=${this.apiKey}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody)
      });

      // If 404, try fallback endpoint
      if (!response.ok && response.status === 404) {
        console.warn('⚠️ Primary model not found, trying fallback:', this.fallbackEndpoint);

        response = await fetch(`${this.fallbackEndpoint}?key=${this.apiKey}`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(requestBody)
        });
      }

      if (!response.ok) {
        const errorData = await response.text();
        console.error('❌ Gemini API error:', errorData);
        return {
          success: false,
          error: `API request failed: ${response.status} - ${response.statusText}`
        };
      }

      const data = await response.json();
      console.log('✅ Gemini API response received for Dreams summary');

      const generatedText = data?.candidates?.[0]?.content?.parts?.[0]?.text;

      if (!generatedText) {
        console.error('❌ No text in response:', JSON.stringify(data, null, 2));
        return {
          success: false,
          error: 'No content generated by AI'
        };
      }

      console.log('✅ Successfully generated Dreams summary, length:', generatedText.length);

      const summary = this.parseDreamsResponse(generatedText);

      if (!summary) {
        return {
          success: false,
          error: 'Failed to parse AI response'
        };
      }

      return {
        success: true,
        summary
      };

    } catch (error) {
      console.error('Error generating Dreams summary:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred'
      };
    }
  }

  /**
   * Parse Dreams summary response (returns portfolio entries as SummaryQuestions structure)
   */
  private parseDreamsResponse(text: string): SummaryQuestions | null {
    try {
      // Remove markdown code blocks if present
      let cleaned = text.trim();
      if (cleaned.startsWith('```json')) {
        cleaned = cleaned.replace(/^```json\s*/, '').replace(/\s*```$/, '');
      } else if (cleaned.startsWith('```')) {
        cleaned = cleaned.replace(/^```\s*/, '').replace(/\s*```$/, '');
      }

      const parsed = JSON.parse(cleaned);

      // Validate structure
      if (!parsed.entries || !Array.isArray(parsed.entries) || parsed.entries.length !== 3) {
        console.error('❌ Invalid Dreams summary structure:', parsed);
        return null;
      }

      // Convert portfolio entries to SummaryQuestions format
      // For Dreams, we'll store it as a structured format
      // question1-3 will contain JSON string of entries, question4 will be empty
      const portfolioJson = JSON.stringify(parsed.entries);
      
      return {
        question1: portfolioJson, // Store full portfolio as JSON string
        question2: '', // Not used for Dreams
        question3: '', // Not used for Dreams
        question4: '' // Not used for Dreams
      };
    } catch (error) {
      console.error('❌ Failed to parse Dreams summary response:', error);
      console.error('Response text:', text);
      return null;
    }
  }

  /**
   * Format School Learning assessment responses for summary
   */
  private formatSchoolLearningResponses(responses: Record<string, any>): string {
    let formatted = '=== MY SCHOOL, MY LEARNING AND I ASSESSMENT ===\n';
    
    Object.entries(responses).forEach(([key, value]) => {
      if (value && typeof value === 'string' && value.trim()) {
        formatted += `${key}: ${value}\n`;
      } else if (value && typeof value === 'object') {
        // Handle checkbox responses (learning methodologies)
        if (key.includes('question11') || key.includes('question')) {
          const checkboxValues = Object.entries(value)
            .filter(([_, checked]) => checked === true)
            .map(([k, _]) => k);
          if (checkboxValues.length > 0) {
            formatted += `${key}: ${checkboxValues.join(', ')}\n`;
          }
          if (value.others && value.others.trim()) {
            formatted += `${key}_others: ${value.others}\n`;
          }
        } else {
          formatted += `${key}: ${JSON.stringify(value)}\n`;
        }
      }
    });
    
    return formatted || 'No responses available';
  }

  /**
   * Build prompt for School Learning assessment summary
   */
  private async buildSchoolLearningPrompt(
    responses: Record<string, any>,
    language: 'en' | 'kn' = 'en'
  ): Promise<string> {
    const formattedResponses = this.formatSchoolLearningResponses(responses);

    // Fetch template from database
    const template = await this.getSummaryTemplate('school_learning');

    if (!template) {
      console.error('Failed to fetch School Learning summary template, falling back to default');
      return this.buildSchoolLearningFallbackPrompt(responses, language);
    }

    const isKannada = language === 'kn';
    const langKey = isKannada ? 'kn' : 'en';

    const languageInstruction = isKannada
      ? '\n\nIMPORTANT LANGUAGE REQUIREMENT:\n- The student\'s responses are in Kannada (ಕನ್ನಡ).\n- You MUST generate your summary answers in Kannada (ಕನ್ನಡ) script.\n- Write all answers in Kannada, maintaining the student\'s natural voice.\n'
      : '';

    // Get questions from database template
    const questions = template[langKey];

    // Instructions for generating summary
    const instructions = isKannada
      ? '- ವಿದ್ಯಾರ್ಥಿಯ ಪ್ರತಿಕ್ರಿಯೆಗಳಿಂದ ನಿಜವಾದ ವಿವರಗಳನ್ನು ಬಳಸಿ\n- ವಿದ್ಯಾರ್ಥಿಯ ಧ್ವನಿಯಲ್ಲಿ ಬರೆಯಿರಿ (ಮೊದಲ ವ್ಯಕ್ತಿ)\n- ಪ್ರತಿಯೊಂದು ಪ್ರಶ್ನೆಗೆ ಸ್ಪಷ್ಟವಾಗಿ ಮತ್ತು ಸಂಕ್ಷಿಪ್ತವಾಗಿ ಉತ್ತರಿಸಿ'
      : '- Use specific details from the student\'s responses\n- Write in the student\'s voice (first person)\n- Be clear and concise for each question';

    const questionsPrompt = `Question 1: ${questions.question1}
${instructions}

Question 2: ${questions.question2}
${instructions}

Question 3: ${questions.question3}
${instructions}

Question 4: ${questions.question4}
${instructions}

Question 5: ${questions.question5}
${instructions}

Question 6: ${questions.question6}
${instructions}`;

    return `You are helping a student in grade 8 or 9 from a rural area in India. They wrote about their school and learning.
Based on what the student wrote below, write a simple summary in easy words.
${languageInstruction}
STUDENT ANSWERS ABOUT SCHOOL AND LEARNING:
${formattedResponses}

Write answers to these 6 questions as if the student is speaking (use "I" and "me").

${questionsPrompt}

IMPORTANT RULES:
- Write like the student is talking (use "I" and "me")
- Use very simple words that a grade 8 or 9 student can easily understand
- Use plain English - no difficult words
- The TOTAL length should be 100-150 words for all six answers together
- Be short and clear
- Use the student's own words from their answers
- Write like the student himself/herself is writing
- Format the response as valid JSON with this exact structure:

{
  "question1": "Your answer here...",
  "question2": "Your answer here...",
  "question3": "Your answer here...",
  "question4": "Your answer here...",
  "question5": "Your answer here...",
  "question6": "Your answer here..."
}

Return ONLY the JSON object, no additional text or markdown formatting.`;
  }

  /**
   * Fallback prompt for School Learning if database fetch fails
   */
  private buildSchoolLearningFallbackPrompt(
    responses: Record<string, any>,
    language: 'en' | 'kn' = 'en'
  ): string {
    const formattedResponses = this.formatSchoolLearningResponses(responses);
    const isKannada = language === 'kn';
    const languageInstruction = isKannada
      ? '\n\nIMPORTANT LANGUAGE REQUIREMENT:\n- The student\'s responses are in Kannada (ಕನ್ನಡ).\n- You MUST generate your summary answers in Kannada (ಕನ್ನಡ) script.\n- Write all answers in Kannada, maintaining the student\'s natural voice.\n'
      : '';

    const questionsPrompt = isKannada
      ? `Question 1: ನನಗೆ ಇಷ್ಟವಾದ ವಿಷಯಗಳು

Question 2: ನನಗೆ ಇಷ್ಟವಾದ ವಿಷಯಗಳಿಂದ ಸಾಧ್ಯವಾದ ವೃತ್ತಿಗಳು

Question 3: ನನಗೆ ಇಷ್ಟವಿಲ್ಲದ ವಿಷಯಗಳು

Question 4: ನನಗೆ ಇಷ್ಟವಿಲ್ಲದ ಆ ವಿಷಯಗಳಲ್ಲಿ ನಾನು ಸುಧಾರಿಸಿದರೆ ಸಾಧ್ಯವಾದ ವೃತ್ತಿಗಳು

Question 5: ಶಾಲೆಯಲ್ಲಿ ಶೈಕ್ಷಣಿಕ ಚಟುವಟಿಕೆಗಳ ಹೊರತಾಗಿ ನಾನು ಚೆನ್ನಾಗಿ ಮಾಡುವ ವಿಷಯಗಳು

Question 6: ಈ ಕೌಶಲ್ಯಗಳನ್ನು ಸುಧಾರಿಸುವುದು ನನ್ನ ವೃತ್ತಿಗೆ ಹೇಗೆ ಸಹಾಯ ಮಾಡುತ್ತದೆ`
      : `Question 1: Subjects I like

Question 2: Careers that are possible of the subjects that I like

Question 3: Subjects I don't like

Question 4: Careers that are possible if I improve in those subjects which I don't like

Question 5: Things I am good at besides academics at school

Question 6: How will improving these skills help me with my career`;

    return `You are a career counselor helping a student create a summary of their school learning assessment.
Based on the student's responses below, generate a thoughtful, personalized summary with 6 questions.
${languageInstruction}
STUDENT RESPONSES FROM MY SCHOOL, MY LEARNING AND I ASSESSMENT:
${formattedResponses}

Please generate answers to these 6 reflection questions in the student's voice (first person).
Be specific, reference actual content from their responses, and keep the tone conversational and age-appropriate.

${questionsPrompt}

IMPORTANT:
- Write in the student's voice (first person)
- Keep each answer to 2-4 concise paragraphs
- Be specific and reference their actual responses
- Use natural, conversational language appropriate for their age
- For Question 1: List the subjects they mentioned liking
- For Question 2: Suggest careers related to those subjects
- For Question 3: List the subjects they mentioned disliking
- For Question 4: Suggest careers that might open up if they improve in disliked subjects
- For Question 5: List their non-academic strengths/skills
- For Question 6: Explain how improving those skills helps with career
- Format the response as valid JSON with this exact structure:

{
  "question1": "Your detailed answer here...",
  "question2": "Your detailed answer here...",
  "question3": "Your detailed answer here...",
  "question4": "Your detailed answer here...",
  "question5": "Your detailed answer here...",
  "question6": "Your detailed answer here..."
}

Return ONLY the JSON object, no additional text or markdown formatting.`;
  }

  /**
   * Generate AI summary for School Learning assessment
   */
  async generateSchoolLearningSummary(
    responses: Record<string, any>
  ): Promise<GenerateSummaryResult> {
    if (!this.isConfigured()) {
      return {
        success: false,
        error: 'Gemini API key is not configured'
      };
    }

    // Validate responses
    if (!responses || Object.keys(responses).length === 0) {
      return {
        success: false,
        error: 'No responses provided from School Learning assessment'
      };
    }

    try {
      // Detect language from student responses
      const allResponseTexts = Object.values(responses)
        .filter(v => typeof v === 'string')
        .join(' ');
      const detectedLanguage = this.containsKannada(allResponseTexts) ? 'kn' : 'en';
      console.log(`🌐 Detected language from student responses: ${detectedLanguage}`);

      const prompt = await this.buildSchoolLearningPrompt(responses, detectedLanguage);

      const requestBody = {
        contents: [
          {
            parts: [
              { text: prompt }
            ]
          }
        ]
      };

      console.log('📡 Calling Gemini API for School Learning summary:', this.endpoint);

      // Try primary endpoint
      let response = await fetch(`${this.endpoint}?key=${this.apiKey}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody)
      });

      // If 404, try fallback endpoint
      if (!response.ok && response.status === 404) {
        console.warn('⚠️ Primary model not found, trying fallback:', this.fallbackEndpoint);

        response = await fetch(`${this.fallbackEndpoint}?key=${this.apiKey}`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(requestBody)
        });
      }

      if (!response.ok) {
        const errorData = await response.text();
        console.error('❌ Gemini API error:', errorData);
        return {
          success: false,
          error: `API request failed: ${response.status} - ${response.statusText}`
        };
      }

      const data = await response.json();
      console.log('✅ Gemini API response received for School Learning summary');

      const generatedText = data?.candidates?.[0]?.content?.parts?.[0]?.text;

      if (!generatedText) {
        console.error('❌ No text in response:', JSON.stringify(data, null, 2));
        return {
          success: false,
          error: 'No content generated by AI'
        };
      }

      console.log('✅ Successfully generated School Learning summary, length:', generatedText.length);

      const summary = this.parseGeminiResponse(generatedText);

      if (!summary) {
        return {
          success: false,
          error: 'Failed to parse AI response'
        };
      }

      return {
        success: true,
        summary
      };

    } catch (error) {
      console.error('Error generating School Learning summary:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred'
      };
    }
  }

  /**
   * Format Hobbies assessment responses for summary
   */
  private formatHobbiesResponses(responses: Record<string, string>): string {
    let formatted = '=== MY TALENTS AND HOBBIES ASSESSMENT ===\n';
    
    Object.entries(responses).forEach(([key, value]) => {
      if (value && typeof value === 'string' && value.trim()) {
        formatted += `${key}: ${value}\n`;
      }
    });
    
    return formatted || 'No responses available';
  }

  /**
   * Build prompt for Hobbies assessment summary
   */
  private async buildHobbiesPrompt(
    responses: Record<string, string>,
    language: 'en' | 'kn' = 'en'
  ): Promise<string> {
    const formattedResponses = this.formatHobbiesResponses(responses);

    // Fetch template from database
    const template = await this.getSummaryTemplate('hobbies');

    if (!template) {
      console.error('Failed to fetch Hobbies summary template, falling back to default');
      return this.buildHobbiesFallbackPrompt(responses, language);
    }

    const isKannada = language === 'kn';
    const langKey = isKannada ? 'kn' : 'en';

    const languageInstruction = isKannada
      ? '\n\nIMPORTANT LANGUAGE REQUIREMENT:\n- The student\'s responses are in Kannada (ಕನ್ನಡ).\n- You MUST generate your summary answers in Kannada (ಕನ್ನಡ) script.\n- Write all entries in Kannada, maintaining the student\'s natural voice.\n'
      : '';

    // Get questions from database template
    const questions = template[langKey];

    // Instructions for generating portfolio
    const instructions = isKannada
      ? '- ಪ್ರತಿಯೊಂದು ಹವ್ಯಾಸ ಮತ್ತು ಪ್ರತಿಭೆಗಾಗಿ, ನಿಮ್ಮ ಪ್ರತಿಕ್ರಿಯೆಗಳಿಂದ ನಿಜವಾದ ವಿವರಗಳನ್ನು ಬಳಸಿ\n- ವಿದ್ಯಾರ್ಥಿಯ ಧ್ವನಿಯಲ್ಲಿ ಬರೆಯಿರಿ (ಮೊದಲ ವ್ಯಕ್ತಿ)\n- ಪ್ರತಿಯೊಂದು ಪ್ರವೇಶಕ್ಕೆ ಸ್ಪಷ್ಟವಾಗಿ ಮತ್ತು ಸಂಕ್ಷಿಪ್ತವಾಗಿ ಉತ್ತರಿಸಿ'
      : '- For each hobby and talent, use specific details from their responses\n- Write in the student\'s voice (first person)\n- Be clear and concise for each entry';

    const hobbiesPrompt = `HOBBIES PORTFOLIO:
Create a hobbies portfolio table with entries. For each entry, fill in:

Column 1: "${questions.question2}" - The hobby name
Column 2: "${questions.question3}" - Whether you would like to turn this hobby into a career
Column 3: "${questions.question4}" - Careers that are compatible with these hobbies
Column 4: "${questions.question5}" - People you know who have turned their hobbies into careers`;

    const talentsPrompt = `TALENTS PORTFOLIO:
Create a talents portfolio table with entries. For each entry, fill in:

Column 1: "${questions.question7}" - The talent name
Column 2: "${questions.question8}" - Whether you want to turn your talent into a career
Column 3: "${questions.question9}" - Careers that match your talents
Column 4: "${questions.question10}" - People you know who have turned their talents into careers`;

    return `You are helping a student in grade 8 or 9 from a rural area in India. They wrote about their hobbies and talents.
Based on what the student wrote below, write a simple summary in easy words.
${languageInstruction}
STUDENT ANSWERS ABOUT HOBBIES AND TALENTS:
${formattedResponses}

Write about their hobbies and talents as if the student is speaking (use "I" and "me").

${hobbiesPrompt}

${talentsPrompt}

${instructions}

IMPORTANT RULES:
- Write about both hobbies and talents
- Write at least 2-3 entries for each
- Each entry should have 4 parts as shown above
- Write like the student is talking (use "I" and "me")
- Use very simple words that a grade 8 or 9 student can easily understand
- Use plain English - no difficult words
- The TOTAL length should be 100-150 words for all entries together
- Be short and clear
- Use the student's own words from their answers
- Write like the student himself/herself is writing
- Format the response as valid JSON with this exact structure:

{
  "hobbiesPortfolio": {
    "entries": [
      {
        "hobby": "Hobby name here",
        "want_career": "Yes/No/Maybe and why",
        "compatible_careers": "List of careers",
        "people_examples": "Names or examples of people"
      }
    ]
  },
  "talentsPortfolio": {
    "entries": [
      {
        "talent": "Talent name here",
        "want_career": "Yes/No/Maybe and why",
        "matching_careers": "List of careers",
        "people_examples": "Names or examples of people"
      }
    ]
  }
}

Return ONLY the JSON object, no additional text or markdown formatting.`;
  }

  /**
   * Fallback prompt for Hobbies if database fetch fails
   */
  private buildHobbiesFallbackPrompt(
    responses: Record<string, string>,
    language: 'en' | 'kn' = 'en'
  ): string {
    const formattedResponses = this.formatHobbiesResponses(responses);

    const isKannada = language === 'kn';
    const langKey = isKannada ? 'kn' : 'en';

    const languageInstruction = isKannada
      ? '\n\nIMPORTANT LANGUAGE REQUIREMENT:\n- The student\'s responses are in Kannada (ಕನ್ನಡ).\n- You MUST generate your summary answers in Kannada (ಕನ್ನಡ) script.\n- Write all entries in Kannada, maintaining the student\'s natural voice.\n'
      : '';

    return `You are a career counselor helping a student create portfolios of their talents and hobbies.
Based on the student's responses below, generate thoughtful, personalized portfolios.
${languageInstruction}
STUDENT RESPONSES FROM MY TALENTS AND HOBBIES ASSESSMENT:
${formattedResponses}

Generate both Hobbies Portfolio and Talents Portfolio in the student's voice (first person).

HOBBIES PORTFOLIO - For each hobby entry:
- Hobbies: The hobby name
- I would like to turn this hobby into a career: Yes/No/Maybe and why
- Careers that are compatible with these hobbies: List of careers
- People you know who have turned their hobbies into careers: Names or examples

TALENTS PORTFOLIO - For each talent entry:
- Talents: The talent name
- Do you want to turn your talent into a career?: Yes/No/Maybe and why
- Careers that match your talents: List of careers
- People you know who have turned their talents into careers: Names or examples

Format the response as valid JSON:
{
  "hobbiesPortfolio": {
    "entries": [
      {
        "hobby": "...",
        "want_career": "...",
        "compatible_careers": "...",
        "people_examples": "..."
      }
    ]
  },
  "talentsPortfolio": {
    "entries": [
      {
        "talent": "...",
        "want_career": "...",
        "matching_careers": "...",
        "people_examples": "..."
      }
    ]
  }
}

Return ONLY the JSON object, no additional text or markdown formatting.`;
  }

  /**
   * Generate AI summary for Hobbies assessment
   */
  async generateHobbiesSummary(
    responses: Record<string, string>
  ): Promise<GenerateSummaryResult> {
    if (!this.isConfigured()) {
      return {
        success: false,
        error: 'Gemini API key is not configured'
      };
    }

    // Validate responses
    if (!responses || Object.keys(responses).length === 0) {
      return {
        success: false,
        error: 'No responses provided from Hobbies assessment'
      };
    }

    try {
      // Detect language from student responses
      const detectedLanguage = this.detectLanguage({ part1: responses });
      console.log(`🌐 Detected language from student responses: ${detectedLanguage}`);

      const prompt = await this.buildHobbiesPrompt(responses, detectedLanguage);

      const requestBody = {
        contents: [
          {
            parts: [
              { text: prompt }
            ]
          }
        ]
      };

      console.log('📡 Calling Gemini API for Hobbies summary:', this.endpoint);

      // Try primary endpoint
      let response = await fetch(`${this.endpoint}?key=${this.apiKey}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody)
      });

      // If 404, try fallback endpoint
      if (!response.ok && response.status === 404) {
        console.warn('⚠️ Primary model not found, trying fallback:', this.fallbackEndpoint);

        response = await fetch(`${this.fallbackEndpoint}?key=${this.apiKey}`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(requestBody)
        });
      }

      if (!response.ok) {
        const errorData = await response.text();
        console.error('❌ Gemini API error:', errorData);
        return {
          success: false,
          error: `API request failed: ${response.status} - ${response.statusText}`
        };
      }

      const data = await response.json();
      console.log('✅ Gemini API response received for Hobbies summary');

      const generatedText = data?.candidates?.[0]?.content?.parts?.[0]?.text;

      if (!generatedText) {
        console.error('❌ No text in response:', JSON.stringify(data, null, 2));
        return {
          success: false,
          error: 'No content generated by AI'
        };
      }

      console.log('✅ Successfully generated Hobbies summary, length:', generatedText.length);

      const summary = this.parseHobbiesResponse(generatedText);

      if (!summary) {
        return {
          success: false,
          error: 'Failed to parse AI response'
        };
      }

      return {
        success: true,
        summary
      };

    } catch (error) {
      console.error('Error generating Hobbies summary:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred'
      };
    }
  }

  /**
   * Parse Hobbies summary response (returns portfolio entries as SummaryQuestions structure)
   */
  private parseHobbiesResponse(text: string): SummaryQuestions | null {
    try {
      // Remove markdown code blocks if present
      let cleaned = text.trim();
      if (cleaned.startsWith('```json')) {
        cleaned = cleaned.replace(/^```json\s*/, '').replace(/\s*```$/, '');
      } else if (cleaned.startsWith('```')) {
        cleaned = cleaned.replace(/^```\s*/, '').replace(/\s*```$/, '');
      }

      const parsed = JSON.parse(cleaned);

      // Validate structure
      if (!parsed.hobbiesPortfolio || !parsed.talentsPortfolio) {
        console.error('❌ Invalid Hobbies summary structure:', parsed);
        return null;
      }

      if (!parsed.hobbiesPortfolio.entries || !Array.isArray(parsed.hobbiesPortfolio.entries)) {
        console.error('❌ Invalid Hobbies Portfolio structure:', parsed.hobbiesPortfolio);
        return null;
      }

      if (!parsed.talentsPortfolio.entries || !Array.isArray(parsed.talentsPortfolio.entries)) {
        console.error('❌ Invalid Talents Portfolio structure:', parsed.talentsPortfolio);
        return null;
      }

      // Convert portfolio entries to SummaryQuestions format
      // Store hobbies portfolio as JSON string in question1
      // Store talents portfolio as JSON string in question6
      const hobbiesJson = JSON.stringify(parsed.hobbiesPortfolio.entries);
      const talentsJson = JSON.stringify(parsed.talentsPortfolio.entries);
      
      return {
        question1: hobbiesJson, // Store hobbies portfolio as JSON string
        question2: '', // Not used for Hobbies
        question3: '', // Not used for Hobbies
        question4: '', // Not used for Hobbies
        question5: '', // Not used for Hobbies
        question6: talentsJson // Store talents portfolio as JSON string
      };
    } catch (error) {
      console.error('❌ Failed to parse Hobbies summary response:', error);
      return null;
    }
  }

  /**
   * Format About Me assessment responses for summary
   */
  private formatAboutMeResponses(responses: Record<string, any>): string {
    let formatted = '=== ABOUT ME ASSESSMENT ===\n';
    
    Object.entries(responses).forEach(([key, value]) => {
      if (value) {
        if (Array.isArray(value)) {
          // Handle triple or double arrays
          formatted += `${key}: ${value.filter(v => v && typeof v === 'string' && v.trim()).join(', ')}\n`;
        } else if (typeof value === 'string' && value.trim()) {
          formatted += `${key}: ${value}\n`;
        }
      }
    });
    
    return formatted || 'No responses available';
  }

  /**
   * Build prompt for About Me assessment summary
   */
  private async buildAboutMePrompt(
    responses: Record<string, any>,
    language: 'en' | 'kn' = 'en'
  ): Promise<string> {
    const formattedResponses = this.formatAboutMeResponses(responses);

    // Fetch template from database
    const template = await this.getSummaryTemplate('about_me');

    if (!template) {
      console.error('Failed to fetch About Me summary template, falling back to default');
      return this.buildAboutMeFallbackPrompt(responses, language);
    }

    const isKannada = language === 'kn';
    const langKey = isKannada ? 'kn' : 'en';

    const languageInstruction = isKannada
      ? '\n\nIMPORTANT LANGUAGE REQUIREMENT:\n- The student\'s responses are in Kannada (ಕನ್ನಡ).\n- You MUST generate your summary answers in Kannada (ಕನ್ನಡ) script.\n- Write all three answers in Kannada, maintaining the student\'s natural voice.\n- Use Kannada script for all text in question1, question2, and question3.\n'
      : '';

    // Get questions from database template
    const questions = template[langKey];

    const listInstruction = isKannada
      ? 'ಪ್ರಶ್ನೆ 1 ಉತ್ತರವನ್ನು 15 ಪ್ರತ್ಯೇಕ ಸಾಲುಗಳಲ್ಲಿ ನೀಡಿ. ಪ್ರತಿಯೊಂದು ಸಾಲು "ವರ್ಗ: ನಾನು ಬರೆದದ್ದು" ವಿನ್ಯಾಸದಲ್ಲಿರಲಿ ಹಾಗೂ ನೀಡಿರುವ ಕ್ರಮದಲ್ಲೇ ಇರಲಿ.'
      : 'Write the answer for Question 1 as 15 separate lines. Use the pattern "Category: What I said" and keep the categories in the given order.';

    const questionsPrompt = `Question 1: ${questions.question1}
${listInstruction}

Question 2: ${questions.question2}

Question 3: ${questions.question3}`;

    return `You are helping a student in grade 8 or 9 from a rural area in India. They wrote about themselves.
Based on what the student wrote below, write a simple summary in easy words.
${languageInstruction}
STUDENT ANSWERS ABOUT THEMSELVES:
${formattedResponses}

Write answers to these 3 questions as if the student is speaking (use "I" and "me").

${questionsPrompt}

IMPORTANT RULES:
- Write like the student is talking (use "I" and "me")
- Use very simple words that a grade 8 or 9 student can easily understand
- Use plain English - no difficult words
- For Question 1, make sure each category is on its own line following the "Category: What I said" pattern
- The TOTAL length should be 100-150 words for all three answers together
- Be short and clear
- Use the student's own words from their answers
- Write like the student himself/herself is writing
- Format the response as valid JSON with this exact structure:

{
  "question1": "Your answer here...",
  "question2": "Your answer here...",
  "question3": "Your answer here..."
}

Return ONLY the JSON object, no additional text or markdown formatting.`;
  }

  /**
   * Fallback prompt for About Me if database fetch fails
   */
  private buildAboutMeFallbackPrompt(
    responses: Record<string, any>,
    language: 'en' | 'kn' = 'en'
  ): string {
    const formattedResponses = this.formatAboutMeResponses(responses);
    const isKannada = language === 'kn';
    const languageInstruction = isKannada
      ? '\n\nIMPORTANT LANGUAGE REQUIREMENT:\n- The student\'s responses are in Kannada (ಕನ್ನಡ).\n- You MUST generate your summary answers in Kannada (ಕನ್ನಡ) script.\n- Write all three answers in Kannada, maintaining the student\'s natural voice.\n- Use Kannada script for all text in question1, question2, and question3.\n'
      : '';

    const listInstruction = isKannada
      ? 'ಪ್ರತಿ ವರ್ಗವನ್ನು "ವರ್ಗ: ನಾನು ಬರೆದದ್ದು" ವಿನ್ಯಾಸದಲ್ಲಿ ತನ್ನದೇ ಸಾಲಿನಲ್ಲಿ ಬರೆಯಿರಿ. ಕ್ರಮವನ್ನು ಹಾಗೆಯೇ ಉಳಿಸಿ.'
      : 'Put each category on its own line using the pattern "Category: What I said" and keep the same order.';

    const questionsPrompt = isKannada
      ? `Question 1: ವಿದ್ಯಾರ್ಥಿಯ ಪ್ರತಿಕ್ರಿಯೆಗಳ ಆಧಾರದ ಮೇಲೆ ಸಮಗ್ರ ಸಾರಾಂಶ ಕೋಷ್ಟಕವನ್ನು ರಚಿಸಿ, ಅವರ ಉತ್ತರಗಳನ್ನು ಈ 15 ವಿಭಾಗಗಳಲ್ಲಿ ಸಂಘಟಿಸಿ: 1) ನನ್ನ ಕುಟುಂಬದಲ್ಲಿನ ಸ್ನೇಹಿತ, 2) ನನ್ನ ಕುಟುಂಬದ ಹೊರಗಿನ ನನ್ನ ಸ್ನೇಹಿತ, 3) ನಾನು ಮನೆಯಲ್ಲಿ ಯಾವ ಚಟುವಟಿಕೆಗಳನ್ನು ಮಾಡುತ್ತಿದ್ದೇನೆ?, 4) ಶಾಲೆಯ ಸಮಯದಲ್ಲಿ ನಾನು ಆನಂದಿಸುವ ಚಟುವಟಿಕೆಗಳು/ಅಂಶಗಳು, 5) ಶಾಲೆಯ ಹೊರಗೆ ನಾನು ಆನಂದಿಸುವ ಚಟುವಟಿಕೆಗಳು/ಅಂಶಗಳು, 6) ನಾನು ವೈಯಕ್ತಿಕವಾಗಿ ಆನಂದಿಸುವ ಕೆಲಸ/ಚಟುವಟಿಕೆಗಳು, 7) ನಾನು ತಂಡವಾಗಿ ಆನಂದಿಸುವ ಕೆಲಸ/ಚಟುವಟಿಕೆಗಳು, 8) ಶಾಲೆಯಲ್ಲಿ ಮಾಡಬೇಕಾದ ಆದರೆ ನನಗೆ ಕಷ್ಟಕರವಾದ ಚಟುವಟಿಕೆ, 9) ಶಾಲೆಯ ನಂತರ ನನಗೆ ಮಾಡಲು ಕಷ್ಟಕರವಾದ ಚಟುವಟಿಕೆ, 10) ನಾನು ಮಾಡಬೇಕಾದ ಚಟುವಟಿಕೆಗಳು, 11) ನನಗೆ ಸ್ವಾಭಾವಿಕವಾಗಿ ಬರುವ ಚಟುವಟಿಕೆಗಳು, 12) ನನಗೆ ಸ್ವಾಭಾವಿಕವಾಗಿ ಬರದ ಚಟುವಟಿಕೆಗಳು, 13) ನನ್ನಲ್ಲಿ ನನಗೆ ಇಷ್ಟವಾದ ಗುಣಗಳು, 14) ಇತರರಲ್ಲಿ ನನಗೆ ಇಷ್ಟವಾದ ಗುಣಗಳು, 15) ನಾನು ಸುಧಾರಿಸಬೇಕಾದ ಗುಣಗಳು. ಪ್ರತಿ ವಿಭಾಗಕ್ಕೂ, ವಿದ್ಯಾರ್ಥಿಯ ನಿಜವಾದ ಪ್ರತಿಕ್ರಿಯೆಗಳ ಆಧಾರದ ಮೇಲೆ ಸಂಕ್ಷಿಪ್ತ ಸಾರಾಂಶವನ್ನು ಒದಗಿಸಿ.
${listInstruction}

Question 2: ಸಾರಾಂಶದ ಆಧಾರದ ಮೇಲೆ ನಿಮ್ಮ ಬಗ್ಗೆ ಸಂಕ್ಷಿಪ್ತ ವಿವರಣೆಯನ್ನು ಬರೆಯಿರಿ. (ನೀವು ಪದಗಳು, ಚಿತ್ರಗಳು ಅಥವಾ ಚಿಹ್ನೆಗಳನ್ನು ಬಳಸಬಹುದು).

Question 3: "ನನ್ನ ಪ್ರೇರಣೆ" ಮತ್ತು "ನನ್ನ ಬಗ್ಗೆ" ನಲ್ಲಿನ ಚಟುವಟಿಕೆಗಳ ಸಾರಾಂಶದ ಆಧಾರದ ಮೇಲೆ, ನಿಮ್ಮ ಪ್ರತಿಯೊಂದು ವೃತ್ತಿ ಆಸಕ್ತಿಗಳಲ್ಲಿ ನಿಮಗೆ ಸಹಾಯ ಮಾಡಬಹುದಾದ ಗುಣಗಳು, ಆಸಕ್ತಿಗಳು, ಶಕ್ತಿಗಳು ಮತ್ತು ಸುಧಾರಣೆಯ ಪ್ರದೇಶಗಳನ್ನು ಗುರುತಿಸಿ. ಇದು ನಿಮ್ಮ ವೃತ್ತಿ ಆಯ್ಕೆಯೊಂದಿಗೆ ನೀವು ಉತ್ತಮವಾಗಿ ಸಮಂಜಸವಾಗಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ.`
      : `Question 1: Create a comprehensive summary table based on the student's responses, organizing their answers into these 15 categories: 1) The friend in my family, 2) My friend outside of my family, 3) What activities am I doing at home?, 4) Activities/aspects I Enjoy during the school hours, 5) Activities/aspects I enjoy outside of the school, 6) Work/activities I enjoy personally, 7) Work/activities I enjoy as a team, 8) Activity that needs to be done in the school but I find difficult, 9) Activity that I find difficult to do after school hours, 10) Activities I must do, 11) Activities that come naturally to me, 12) Activities that don't come naturally to me, 13) Qualities I like in myself, 14) Qualities that others like in me, 15) Qualities that I need to improve on. For each category, provide a concise summary based on the student's actual responses.
${listInstruction}

Question 2: Write a brief description of yourself based on the summary. (You can use words, pictures or symbols).

Question 3: Based on the summary of "My Motivation" and the activities in "About Me," identify the qualities, interests, strengths, and areas for improvement that would help you in each of your career interests. This will help you align better with your career choice.`;

    return `You are helping a student in grade 8 or 9 from a rural area in India. They wrote about themselves.
Based on what the student wrote below, write a simple summary in easy words.
${languageInstruction}
STUDENT ANSWERS ABOUT THEMSELVES:
${formattedResponses}

Write answers to these 3 questions as if the student is speaking (use "I" and "me").

${questionsPrompt}

IMPORTANT RULES:
- Write like the student is talking (use "I" and "me")
- Use very simple words that a grade 8 or 9 student can easily understand
- Use plain English - no difficult words
- The TOTAL length should be 100-150 words for all three answers together
- Be short and clear
- Use the student's own words from their answers
- Write like the student himself/herself is writing
- Format the response as valid JSON with this exact structure:

{
  "question1": "Your answer here...",
  "question2": "Your answer here...",
  "question3": "Your answer here..."
}

Return ONLY the JSON object, no additional text or markdown formatting.`;
  }

  /**
   * Generate AI summary for About Me assessment
   */
  async generateAboutMeSummary(
    responses: Record<string, any>
  ): Promise<GenerateSummaryResult> {
    if (!this.isConfigured()) {
      return {
        success: false,
        error: 'Gemini API key is not configured'
      };
    }

    // Validate responses
    if (!responses || Object.keys(responses).length === 0) {
      return {
        success: false,
        error: 'No responses provided from About Me assessment'
      };
    }

    try {
      // Detect language from student responses
      const detectedLanguage = this.detectLanguage({ part1: responses });
      console.log(`🌐 Detected language from student responses: ${detectedLanguage}`);

      const prompt = await this.buildAboutMePrompt(responses, detectedLanguage);

      const requestBody = {
        contents: [
          {
            parts: [
              { text: prompt }
            ]
          }
        ]
      };

      console.log('📡 Calling Gemini API for About Me summary:', this.endpoint);

      // Try primary endpoint
      let response = await fetch(`${this.endpoint}?key=${this.apiKey}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody)
      });

      // If 404, try fallback endpoint
      if (!response.ok && response.status === 404) {
        console.warn('⚠️ Primary model not found, trying fallback:', this.fallbackEndpoint);

        response = await fetch(`${this.fallbackEndpoint}?key=${this.apiKey}`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(requestBody)
        });
      }

      if (!response.ok) {
        const errorData = await response.text();
        console.error('❌ Gemini API error:', errorData);
        return {
          success: false,
          error: `API request failed: ${response.status} - ${response.statusText}`
        };
      }

      const data = await response.json();
      console.log('✅ Gemini API response received for About Me');

      const generatedText = data?.candidates?.[0]?.content?.parts?.[0]?.text;

      if (!generatedText) {
        console.error('❌ No text in response:', JSON.stringify(data, null, 2));
        return {
          success: false,
          error: 'No content generated by AI'
        };
      }

      console.log('✅ Successfully generated About Me summary, length:', generatedText.length);

      const summary = this.parseGeminiResponse(generatedText);

      if (!summary) {
        return {
          success: false,
          error: 'Failed to parse AI response'
        };
      }

      return {
        success: true,
        summary
      };

    } catch (error) {
      console.error('Error generating About Me summary:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred'
      };
    }
  }

  /**
   * Format Role Models assessment responses for summary
   */
  private formatRoleModelsResponses(responses: Record<string, any>): string {
    let formatted = '=== MY ROLE MODELS ASSESSMENT ===\n';
    
    // Role Models has roleModel1, roleModel2, roleModel3 structure
    if (responses.roleModel1 || responses.roleModel2 || responses.roleModel3) {
      ['roleModel1', 'roleModel2', 'roleModel3'].forEach((key, index) => {
        const roleModel = responses[key];
        if (roleModel && typeof roleModel === 'object') {
          formatted += `\n--- Role Model ${index + 1} ---\n`;
          Object.entries(roleModel).forEach(([field, value]) => {
            if (value && typeof value === 'string' && value.trim()) {
              formatted += `${field}: ${value}\n`;
            }
          });
        }
      });
    } else {
      // Fallback: format all fields
      Object.entries(responses).forEach(([key, value]) => {
        if (value && typeof value === 'string' && value.trim()) {
          formatted += `${key}: ${value}\n`;
        } else if (value && typeof value === 'object') {
          formatted += `${key}: ${JSON.stringify(value)}\n`;
        }
      });
    }
    
    return formatted || 'No responses available';
  }

  /**
   * Build prompt for Role Models assessment summary
   */
  private async buildRoleModelsPrompt(
    responses: Record<string, any>,
    language: 'en' | 'kn' = 'en'
  ): Promise<string> {
    const formattedResponses = this.formatRoleModelsResponses(responses);

    // Fetch template from database
    const template = await this.getSummaryTemplate('role_models');

    if (!template) {
      console.error('Failed to fetch Role Models summary template, falling back to default');
      return this.buildRoleModelsFallbackPrompt(responses, language);
    }

    const isKannada = language === 'kn';
    const langKey = isKannada ? 'kn' : 'en';

    const languageInstruction = isKannada
      ? '\n\nIMPORTANT LANGUAGE REQUIREMENT:\n- The student\'s responses are in Kannada (ಕನ್ನಡ).\n- You MUST generate your summary answers in Kannada (ಕನ್ನಡ) script.\n- Write the answer in Kannada, maintaining the student\'s natural voice.\n- Use Kannada script for all text in question1.\n'
      : '';

    // Get questions from database template
    const questions = template[langKey];

    const questionsPrompt = `Question 1: ${questions.question1}`;

    return `You are helping a student in grade 8 or 9 from a rural area in India. They wrote about their role models.
Based on what the student wrote below, write a simple summary in easy words.
${languageInstruction}
STUDENT ANSWERS ABOUT THEIR ROLE MODELS:
${formattedResponses}

Write an answer to this question as if the student is speaking (use "I" and "me").

${questionsPrompt}

IMPORTANT RULES:
- Write like the student is talking (use "I" and "me")
- Use very simple words that a grade 8 or 9 student can easily understand
- Use plain English - no difficult words
- The TOTAL length should be 100-150 words
- Be short and clear
- Use the student's own words from their answers
- Write like the student himself/herself is writing
- Format the response as valid JSON with this exact structure:

{
  "question1": "Your answer here..."
}

Return ONLY the JSON object, no additional text or markdown formatting.`;
  }

  /**
   * Fallback prompt for Role Models if database fetch fails
   */
  private buildRoleModelsFallbackPrompt(
    responses: Record<string, any>,
    language: 'en' | 'kn' = 'en'
  ): string {
    const formattedResponses = this.formatRoleModelsResponses(responses);
    const isKannada = language === 'kn';
    const languageInstruction = isKannada
      ? '\n\nIMPORTANT LANGUAGE REQUIREMENT:\n- The student\'s responses are in Kannada (ಕನ್ನಡ).\n- You MUST generate your summary answers in Kannada (ಕನ್ನಡ) script.\n- Write the answer in Kannada, maintaining the student\'s natural voice.\n- Use Kannada script for all text in question1.\n'
      : '';

    const questionsPrompt = isKannada
      ? `Question 1: ನಿಮ್ಮ ಪಾತ್ರ ಮಾದರಿಗಳಿಂದ ವೃತ್ತಿ ಮಾರ್ಗದರ್ಶನದ ಕುರಿತಾಗಿ ನೀವು ಕೇಳಲು ಬಯಸುವ 5 ರಿಂದ 10 ಪ್ರಶ್ನೆಗಳನ್ನು ಬರೆಯಿರಿ.`
      : `Question 1: Write down 5 to 10 questions you would like to ask your role models about career guidance.`;

    return `You are helping a student in grade 8 or 9 from a rural area in India. They wrote about their role models.
Based on what the student wrote below, write a simple summary in easy words.
${languageInstruction}
STUDENT ANSWERS ABOUT THEIR ROLE MODELS:
${formattedResponses}

Write an answer to this question as if the student is speaking (use "I" and "me").

${questionsPrompt}

IMPORTANT RULES:
- Write like the student is talking (use "I" and "me")
- Use very simple words that a grade 8 or 9 student can easily understand
- Use plain English - no difficult words
- The TOTAL length should be 100-150 words
- Be short and clear
- Use the student's own words from their answers
- Write like the student himself/herself is writing
- Format the response as valid JSON with this exact structure:

{
  "question1": "Your answer here..."
}

Return ONLY the JSON object, no additional text or markdown formatting.`;
  }

  /**
   * Generate AI summary for Role Models assessment
   */
  async generateRoleModelsSummary(
    responses: Record<string, any>
  ): Promise<GenerateSummaryResult> {
    if (!this.isConfigured()) {
      return {
        success: false,
        error: 'Gemini API key is not configured'
      };
    }

    // Validate responses
    if (!responses || Object.keys(responses).length === 0) {
      return {
        success: false,
        error: 'No responses provided from Role Models assessment'
      };
    }

    try {
      // Detect language from student responses
      const detectedLanguage = this.detectLanguage({ part1: responses });
      console.log(`🌐 Detected language from student responses: ${detectedLanguage}`);

      const prompt = await this.buildRoleModelsPrompt(responses, detectedLanguage);

      const requestBody = {
        contents: [
          {
            parts: [
              { text: prompt }
            ]
          }
        ]
      };

      console.log('📡 Calling Gemini API for Role Models summary:', this.endpoint);

      // Try primary endpoint
      let response = await fetch(`${this.endpoint}?key=${this.apiKey}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody)
      });

      // If 404, try fallback endpoint
      if (!response.ok && response.status === 404) {
        console.warn('⚠️ Primary model not found, trying fallback:', this.fallbackEndpoint);

        response = await fetch(`${this.fallbackEndpoint}?key=${this.apiKey}`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(requestBody)
        });
      }

      if (!response.ok) {
        const errorData = await response.text();
        console.error('❌ Gemini API error:', errorData);
        return {
          success: false,
          error: `API request failed: ${response.status} - ${response.statusText}`
        };
      }

      const data = await response.json();
      console.log('✅ Gemini API response received for Role Models summary');

      const generatedText = data?.candidates?.[0]?.content?.parts?.[0]?.text;

      if (!generatedText) {
        console.error('❌ No text in response:', JSON.stringify(data, null, 2));
        return {
          success: false,
          error: 'No content generated by AI'
        };
      }

      console.log('✅ Successfully generated Role Models summary, length:', generatedText.length);
      console.log('📄 Generated text (first 500 chars):', generatedText.substring(0, 500));

      const summary = this.parseGeminiResponse(generatedText);

      if (!summary) {
        console.error('❌ Failed to parse Role Models summary. Full response:', generatedText);
        return {
          success: false,
          error: 'Failed to parse AI response. Please check the console for details.'
        };
      }
      
      console.log('✅ Successfully parsed Role Models summary:', summary);

      return {
        success: true,
        summary
      };

    } catch (error) {
      console.error('Error generating Role Models summary:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred'
      };
    }
  }
}

// Export singleton instance
export const aiSummaryService = new AISummaryService();

