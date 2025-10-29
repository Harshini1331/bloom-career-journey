// Database validation utilities to check if functions exist

import { supabase } from '@/integrations/supabase/client';

export interface DatabaseFunctionStatus {
  functionName: string;
  exists: boolean;
  error?: string;
}

export class DatabaseValidator {
  private static functionCache = new Map<string, boolean>();

  /**
   * Check if a database function exists by attempting to call it
   */
  static async checkFunctionExists(functionName: string): Promise<DatabaseFunctionStatus> {
    // Check cache first
    if (this.functionCache.has(functionName)) {
      return {
        functionName,
        exists: this.functionCache.get(functionName)!
      };
    }

    try {
      // Try to call the function with minimal parameters
      const { error } = await supabase.rpc(functionName);
      
      // If we get a "function does not exist" error, the function doesn't exist
      if (error && error.message.includes('function') && error.message.includes('does not exist')) {
        this.functionCache.set(functionName, false);
        return {
          functionName,
          exists: false,
          error: error.message
        };
      }

      // If we get any other error, the function exists but has parameter issues
      this.functionCache.set(functionName, true);
      return {
        functionName,
        exists: true
      };
    } catch (err) {
      this.functionCache.set(functionName, false);
      return {
        functionName,
        exists: false,
        error: err instanceof Error ? err.message : 'Unknown error'
      };
    }
  }

  /**
   * Check all required database functions
   */
  static async checkAllFunctions(): Promise<DatabaseFunctionStatus[]> {
    const requiredFunctions = [
      'get_holland_code_questions',
      'get_inspiration_questions',
      'get_inspiration_videos',
      'get_dreams_questions',
      'get_school_learning_questions',
      'get_school_learning_options'
    ];

    const results = await Promise.all(
      requiredFunctions.map(func => this.checkFunctionExists(func))
    );

    return results;
  }

  /**
   * Get a summary of database function status
   */
  static async getDatabaseStatus(): Promise<{
    totalFunctions: number;
    existingFunctions: number;
    missingFunctions: string[];
    status: 'healthy' | 'degraded' | 'broken';
  }> {
    const results = await this.checkAllFunctions();
    const existingFunctions = results.filter(r => r.exists);
    const missingFunctions = results.filter(r => !r.exists).map(r => r.functionName);

    let status: 'healthy' | 'degraded' | 'broken';
    if (missingFunctions.length === 0) {
      status = 'healthy';
    } else if (missingFunctions.length < results.length / 2) {
      status = 'degraded';
    } else {
      status = 'broken';
    }

    return {
      totalFunctions: results.length,
      existingFunctions: existingFunctions.length,
      missingFunctions,
      status
    };
  }

  /**
   * Clear the function cache (useful for testing)
   */
  static clearCache(): void {
    this.functionCache.clear();
  }
}
