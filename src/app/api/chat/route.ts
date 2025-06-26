// src/app/api/chat/route.ts
import OpenAI from 'openai';
import { streamText } from 'ai';
import { openai as openaiProvider } from '@ai-sdk/openai';
import { NextResponse } from 'next/server';

// 如果上面的导入有问题，使用下面这种方式
// import { openai } from 'ai/providers/openai';

export const runtime = 'edge';

// 处理 CORS
function corsHeaders() {
    return {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
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
        const { messages, memoContent } = await req.json();

        // 如果是第一条消息且包含 memo 内容，添加系统提示
        let processedMessages = messages;
        if (memoContent && messages.length === 1) {
            processedMessages = [
                {
                    role: 'system',
                    content: `你是一个智能助手，正在帮助用户分析和讨论以下笔记内容：

笔记内容：
${memoContent}

请根据用户的问题，结合这篇笔记的内容进行回答。如果用户询问总结，请提供简洁且有用的总结。`
                },
                ...messages
            ];
        }

        const result = await streamText({
            model: openaiProvider('gpt-4o-mini'),
            messages: processedMessages,
            temperature: 0.7,
        });

        return result.toAIStreamResponse({
            headers: corsHeaders(),
        });
    } catch (error) {
        console.error('Chat API Error:', error);
        return NextResponse.json(
            { error: 'Internal Server Error' },
            {
                status: 500,
                headers: corsHeaders(),
            }
        );
    }
}