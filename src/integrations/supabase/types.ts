export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      activities: {
        Row: {
          id: string
          title: string
          description: string
          sequence_number: number
          created_at: string
        }
        Insert: {
          id?: string
          title: string
          description: string
          sequence_number: number
          created_at?: string
        }
        Update: {
          id?: string
          title?: string
          description?: string
          sequence_number?: number
          created_at?: string
        }
      }
      assessment_responses: {
        Row: {
          id: string
          student_id: string
          assessment_type: 'inspiration' | 'dreams' | 'school_learning' | 'role_models' | 'hobbies' | 'personality' | 'career_aptitude'
          assessment_title: string
          responses: Json
          completed_at: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          student_id: string
          assessment_type: 'inspiration' | 'dreams' | 'school_learning' | 'role_models' | 'hobbies' | 'personality' | 'career_aptitude'
          assessment_title: string
          responses: Json
          completed_at?: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          assessment_type?: 'inspiration' | 'dreams' | 'school_learning' | 'role_models' | 'hobbies' | 'personality' | 'career_aptitude'
          assessment_title?: string
          responses?: Json
          completed_at?: string
          created_at?: string
          updated_at?: string
        }
      }
      classes: {
        Row: {
          id: string
          name: string
          school_id: string
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          school_id: string
          created_at?: string
        }
        Update: {
          id?: string
          name?: string
          school_id?: string
          created_at?: string
        }
      }
      inspiration_sources: {
        Row: {
          id: string
          title: string
          url: string
          description: string | null
          sequence_number: number
          is_active: boolean
          created_at: string
        }
        Insert: {
          id?: string
          title: string
          url: string
          description?: string | null
          sequence_number?: number
          is_active?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          title?: string
          url?: string
          description?: string | null
          sequence_number?: number
          is_active?: boolean
          created_at?: string
        }
      }
      orgs: {
        Row: {
          id: string
          name: string
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          created_at?: string
        }
        Update: {
          id?: string
          name?: string
          created_at?: string
        }
      }
      schools: {
        Row: {
          id: string
          name: string
          org_id: string
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          org_id: string
          created_at?: string
        }
        Update: {
          id?: string
          name?: string
          org_id?: string
          created_at?: string
        }
      }
      student_activity_progress: {
        Row: {
          id: string
          student_id: string
          activity_id: string
          status: string
          results: string | null
          completed_at: string | null
          created_at: string
        }
        Insert: {
          id?: string
          student_id: string
          activity_id: string
          status: string
          results?: string | null
          completed_at?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          activity_id?: string
          status?: string
          results?: string | null
          completed_at?: string | null
          created_at?: string
        }
      }
      students: {
        Row: {
          id: string
          user_id: string
          class_id: string
          teacher_id: string
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          class_id: string
          teacher_id: string
          created_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          class_id?: string
          teacher_id?: string
          created_at?: string
        }
      }
      teachers: {
        Row: {
          id: string
          user_id: string
          school_id: string
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          school_id: string
          created_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          school_id?: string
          created_at?: string
        }
      }
      users: {
        Row: {
          id: string
          password_hash: string
          role: 'admin' | 'teacher' | 'student'
          full_name: string
          mobile: string | null
          email: string
          created_at: string
        }
        Insert: {
          id: string
          password_hash?: string
          role: 'admin' | 'teacher' | 'student'
          full_name: string
          mobile?: string | null
          email: string
          created_at?: string
        }
        Update: {
          id?: string
          password_hash?: string
          role?: 'admin' | 'teacher' | 'student'
          full_name?: string
          mobile?: string | null
          email?: string
          created_at?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      get_student_assessment_responses: {
        Args: {
          teacher_user_id: string
          assessment_type_filter?: 'inspiration' | 'dreams' | 'school_learning' | 'role_models' | 'hobbies' | 'personality' | 'career_aptitude'
        }
        Returns: {
          student_name: string
          student_class: string
          assessment_title: string
          responses: Json
          completed_at: string
        }[]
      }
    }
    Enums: {
      assessment_type: 'inspiration' | 'dreams' | 'school_learning' | 'role_models' | 'hobbies' | 'personality' | 'career_aptitude'
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      app_role: ["admin", "teacher", "student"],
    },
  },
} as const
