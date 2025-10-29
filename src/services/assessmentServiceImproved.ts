import { supabase } from '@/integrations/supabase/client';

export interface HollandCodeQuestion {
  category: string;
  question_text: string;
  sequence_number: number;
}

export interface InspirationQuestion {
  id: string;
  question_text: string;
  help_text: string | null;
  sequence_number: number;
}

export interface InspirationVideo {
  id: string;
  title: string;
  url: string;
  youtube_id: string | null;
  description: string | null;
  sequence_number: number;
}

export interface DreamsQuestion {
  id: string;
  section: string;
  question_text: string;
  help_text: string | null;
  sequence_number: number;
}

export interface SchoolLearningQuestion {
  id: string;
  section: string;
  question_text: string;
  question_type: string;
  help_text: string | null;
  sequence_number: number;
}

export interface SchoolLearningOption {
  id: string;
  option_text: string;
  option_value: string;
  sequence_number: number;
}

export class AssessmentServiceImproved {
  /**
   * Get Holland Code questions organized by category
   */
  static async getHollandCodeQuestions(): Promise<{ [key: string]: string[] } | null> {
    try {
      const { data, error } = await supabase.rpc('get_holland_code_questions');

      if (error) {
        console.error('Error fetching Holland Code questions:', error);
        return null;
      }

      // Organize questions by category
      const questions: { [key: string]: string[] } = {};
      data.forEach((q: HollandCodeQuestion) => {
        if (!questions[q.category]) {
          questions[q.category] = [];
        }
        questions[q.category].push(q.question_text);
      });

      return questions;
    } catch (error) {
      console.error('Error in getHollandCodeQuestions:', error);
      return null;
    }
  }

  /**
   * Get Inspiration questions
   */
  static async getInspirationQuestions(): Promise<InspirationQuestion[]> {
    try {
      const { data, error } = await supabase.rpc('get_inspiration_questions');

      if (error) {
        console.error('Error fetching Inspiration questions:', error);
        return [];
      }

      return data as InspirationQuestion[];
    } catch (error) {
      console.error('Error in getInspirationQuestions:', error);
      return [];
    }
  }

  /**
   * Get Inspiration videos
   */
  static async getInspirationVideos(): Promise<InspirationVideo[]> {
    try {
      const { data, error } = await supabase.rpc('get_inspiration_videos');

      if (error) {
        console.error('Error fetching Inspiration videos:', error);
        return [];
      }

      return data as InspirationVideo[];
    } catch (error) {
      console.error('Error in getInspirationVideos:', error);
      return [];
    }
  }

  /**
   * Get Dreams questions organized by section
   */
  static async getDreamsQuestions(): Promise<{ [key: string]: DreamsQuestion[] }> {
    try {
      const { data, error } = await supabase.rpc('get_dreams_questions');

      if (error) {
        console.error('Error fetching Dreams questions:', error);
        return {};
      }

      // Organize questions by section
      const questions: { [key: string]: DreamsQuestion[] } = {};
      data.forEach((q: DreamsQuestion) => {
        if (!questions[q.section]) {
          questions[q.section] = [];
        }
        questions[q.section].push(q);
      });

      return questions;
    } catch (error) {
      console.error('Error in getDreamsQuestions:', error);
      return {};
    }
  }

  /**
   * Get School Learning questions organized by section
   */
  static async getSchoolLearningQuestions(): Promise<{ [key: string]: SchoolLearningQuestion[] }> {
    try {
      const { data, error } = await supabase.rpc('get_school_learning_questions');

      if (error) {
        console.error('Error fetching School Learning questions:', error);
        return {};
      }

      // Organize questions by section
      const questions: { [key: string]: SchoolLearningQuestion[] } = {};
      data.forEach((q: SchoolLearningQuestion) => {
        if (!questions[q.section]) {
          questions[q.section] = [];
        }
        questions[q.section].push(q);
      });

      return questions;
    } catch (error) {
      console.error('Error in getSchoolLearningQuestions:', error);
      return {};
    }
  }

  /**
   * Get School Learning options for a specific question
   */
  static async getSchoolLearningOptions(questionId: string): Promise<SchoolLearningOption[]> {
    try {
      const { data, error } = await supabase.rpc('get_school_learning_options', {
        p_question_id: questionId
      });

      if (error) {
        console.error('Error fetching School Learning options:', error);
        return [];
      }

      return data as SchoolLearningOption[];
    } catch (error) {
      console.error('Error in getSchoolLearningOptions:', error);
      return [];
    }
  }

  /**
   * Update Holland Code question
   */
  static async updateHollandCodeQuestion(
    questionId: string,
    questionText?: string,
    sequenceNumber?: number
  ): Promise<boolean> {
    try {
      const { error } = await supabase.rpc('update_holland_code_question', {
        p_question_id: questionId,
        p_question_text: questionText,
        p_sequence_number: sequenceNumber
      });

      if (error) {
        console.error('Error updating Holland Code question:', error);
        return false;
      }

      return true;
    } catch (error) {
      console.error('Error in updateHollandCodeQuestion:', error);
      return false;
    }
  }

  /**
   * Update Inspiration question
   */
  static async updateInspirationQuestion(
    questionId: string,
    questionText?: string,
    helpText?: string
  ): Promise<boolean> {
    try {
      const { error } = await supabase.rpc('update_inspiration_question', {
        p_question_id: questionId,
        p_question_text: questionText,
        p_help_text: helpText
      });

      if (error) {
        console.error('Error updating Inspiration question:', error);
        return false;
      }

      return true;
    } catch (error) {
      console.error('Error in updateInspirationQuestion:', error);
      return false;
    }
  }

  /**
   * Update Inspiration video
   */
  static async updateInspirationVideo(
    videoId: string,
    title?: string,
    url?: string,
    description?: string
  ): Promise<boolean> {
    try {
      const { error } = await supabase.rpc('update_inspiration_video', {
        p_video_id: videoId,
        p_title: title,
        p_url: url,
        p_description: description
      });

      if (error) {
        console.error('Error updating Inspiration video:', error);
        return false;
      }

      return true;
    } catch (error) {
      console.error('Error in updateInspirationVideo:', error);
      return false;
    }
  }
}
