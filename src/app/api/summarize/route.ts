// src/app/api/summarize/route.ts
import OpenAI from 'openai';
import { NextResponse } from 'next/server';

const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
    baseURL: 'https://api.deepseek.com',
});

export const runtime = 'edge';

// 增强的CORS配置
function corsHeaders() {
    return {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Requested-With, Accept, Origin',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Max-Age': '86400',
    };
}

export async function OPTIONS(request: Request) {
    return new NextResponse(null, {
        status: 200,
        headers: corsHeaders(),
    });
}

export async function POST(req: Request) {
    try {
        const { content } = await req.json();

        if (!content) {
            return NextResponse.json(
                { error: '缺少笔记内容' },
                {
                    status: 400,
                    headers: corsHeaders(),
                }
            );
        }

        const response = await openai.chat.completions.create({
            model: 'deepseek-chat',
            messages: [
                {
                    role: 'system',
                    content: '你是一个专业的内容总结助手。请为用户提供简洁、准确、有用的内容总结。总结应该突出要点，保持逻辑清晰。'
                },
                {
                    role: 'user',
                    content: `请为以下内容提供一个简洁的总结：\n\n${content}`
                }
            ],
            temperature: 0.3,
            max_tokens: 500,
        });

        const summary = response.choices[0]?.message?.content || '无法生成总结';

        return NextResponse.json(
            { summary },
            { headers: corsHeaders() }
        );
    } catch (error) {
        console.error('Summarize API Error:', error);
        return NextResponse.json(
            { error: '生成总结时出错' },
            {
                status: 500,
                headers: corsHeaders(),
            }
        );
    }
}
