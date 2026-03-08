import React from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import type { StudentLang } from './studentStrings';

export interface ProgressRowData {
    number: number;
    titleKey: string;
    assessmentType: string;
    bgColor: string;
    textColor: string;
    isCompleted: boolean;
    previousCompleted: boolean;
}

interface ProgressSectionProps {
    rows: ProgressRowData[];
    resolvedLang: StudentLang;
    t: (k: string) => string;
    hollandCodeCompleted: boolean;
    roleModelsCompleted: boolean;
    careerGuidanceToolsCompleted: boolean;
    hollandCodeCompleted2: boolean;
}

export default function ProgressSection({
    rows,
    resolvedLang,
    t,
    hollandCodeCompleted,
    roleModelsCompleted,
    careerGuidanceToolsCompleted,
    hollandCodeCompleted2,
}: ProgressSectionProps) {
    return (
        <Card className="border-0 shadow-lg">
            <CardHeader>
                <CardTitle className="text-xl text-gray-800">{t('progress_summary_title')}</CardTitle>
                <CardDescription>{t('progress_summary_desc')}</CardDescription>
            </CardHeader>
            <CardContent>
                <div className="space-y-3">
                    {rows.map((row) => (
                        <div key={row.assessmentType} className={`flex items-center justify-between p-3 ${row.bgColor} rounded-lg`}>
                            <span className={`font-medium ${row.textColor}`}>{row.number}. {t(row.titleKey)}</span>
                            <Badge variant={row.isCompleted ? "default" : (row.previousCompleted ? "secondary" : "outline")}>
                                {row.isCompleted ? t('completed') : (row.previousCompleted ? t('available') : t('locked'))}
                            </Badge>
                        </div>
                    ))}
                    {/* 7. Holland Code */}
                    <div className="flex items-center justify-between p-3 bg-teal-50 rounded-lg">
                        <span className="font-medium text-teal-800">7. {t('assessment_holland_code')}</span>
                        <Badge variant={hollandCodeCompleted ? "default" : (roleModelsCompleted ? "secondary" : "outline")}>
                            {hollandCodeCompleted ? t('completed') : (roleModelsCompleted ? t('available') : t('locked'))}
                        </Badge>
                    </div>
                    {/* 8. Career Guidance */}
                    <div className="flex items-center justify-between p-3 bg-indigo-50 rounded-lg">
                        <span className="font-medium text-indigo-800">8. {t('assessment_career_guidance')}</span>
                        <Badge variant={careerGuidanceToolsCompleted ? "default" : (hollandCodeCompleted2 ? "secondary" : "outline")}>
                            {careerGuidanceToolsCompleted ? t('completed') : (hollandCodeCompleted2 ? t('available') : t('locked'))}
                        </Badge>
                    </div>
                </div>
            </CardContent>
        </Card>
    );
}
