


# 1.如何构建企业级知识库
## 1.x 基本流程
```
写知识库：将知识库经过 ai 处理入库
读知识库：人类检索召回
反馈纠错：提升知识库质量
```

## 1.1 问题
```
1.context (page context, field context, error context, openapi context etc)
2.self-evolution: correction && feedback
3.permission control(not all the person can see all the doc)
4.documents quality is very important
5.documents changes/updates, then???
6.documents history save???
7.RAG 等是黑盒等，幻觉不可避免
```

## 1.2 核心 (非单次的检索和回复)
### 1.2.1 意图识别 (intent recognize / intent classification)
```
1.意图识别等策略是什么？
>> 引入模型？？
>> 引入字典？？
... ...
```

```
以下是目前行业内常用的 Query Embedding 模型，覆盖闭源商用和开源可部署两大类别：

一、闭源商用主流模型
OpenAI 系列‌
代表模型：text-embedding-3-small、text-embedding-3-large
核心特点：多语言支持能力强，成本更低，可自定义向量维度，是RAG场景的经典选型。
Google Gemini Embedding
核心特点：2026年3月发布的全模态模型，支持文本、图像等5种模态的统一嵌入，适配多模态检索场景。
Cohere Embed
核心特点：MTEB榜单的常客，纯文本语义理解表现优异，在通用检索场景落地广泛。

二、开源可部署主流模型
BGE 系列‌
代表模型：bge-small-zh-v1.5、bge-base-zh-v1.5、BGE-M3
核心特点：中文领域标杆，BGE-M3支持100+种语言，不同大小版本适配从边缘设备到大显存服务器的各类场景。
Jina 系列‌
代表模型：jina-embeddings-v5-text、Jina Embeddings v4
核心特点：原生支持多语言语义检索，可通过不同LoRA适配器切换检索场景，已被Elasticsearch作为默认语义嵌入模型集成。
Sentence-Transformers 轻量系列‌
代表模型：all-MiniLM-L6-v2、all-mpnet-base-v2
核心特点：体积小、推理速度快，在低延迟生产环境中表现稳定，是入门级项目的高性价比选型。
其他热门开源模型‌
代表模型：mxbai-embed-large、nomic-embed-text
核心特点：参数量轻量，英文场景下MRL维度压缩表现突出，适合资源受限的部署环境。
```

### 1.2.2 查询重写 (query rewrite) 
```
1.查询重写的目的：
>> 语义鸿沟：口语提问和知识库文本不一致，直接检索几乎找不到
>> 意图模糊：缺少 context 的提问几乎会导致误判
>> context 缺失：多轮对话之后，需要保存历史记录，保证记忆

2.如何改写：
>> 规则改写：
关键词补全，同义词替换，固定指代替换。适用于业务场景快速启动。
但覆盖场景有限。

>> NLP 改写：
实体识别，同义词扩展，浅层上下文融合，速度快，算力成本低。
但专业领域专有名词就需要高成本跨行业适配了。

>> 大模型改写（主流）：
跨多轮语义补全，拓展召回维度，口语化转为书面语，适用于多轮对话，复杂意图，对齐质量要求高的场景。

3.大模型改写的几种方案
>> 语义增强型：HyDE
先生成答案，以答案去知识库搜答案
>> 任务分解型：Step- back/子查询
适用于分析类多意图查询
>> 上下文补全型
适合多轮连续对话

4.大模型改写落地的坑
>> 延迟问题，耗时
可用微调后的小模型改写，或者改写与初筛检索并行。

>> 查询漂移
加入语义相似度校验，相似度 < 阈值，则弃用

>> 成本问题
加路由，简单问候，明确短问题，直接跳过。
仅仅对意图模糊，复杂，多轮对话的进行改写。
```

### 1.2.3 语义召回(recall rate / multiple recall)
```
语义召回是搜索系统中依托语义匹配实现结果召回的核心技术‌，它区别于传统字面关键词匹配，
能召回语义相关但字面不重合的内容，大幅提升搜索的召回效果上限。
```

### 1.2.4 知识图谱 (knowledge graph)

### 1.2.5 重排序 (reranker)

### 1.2.6 向量数据库
```
数据准备(pdf/doc/md/png/video/txt) -->
文档切分(要按照语义切分，保留100～200token重叠保证连贯性) -->
向量化 (用 Embedding 模型将文本映射至512～1536空间 -->
持续优化（监控召回率，定期更新策略）
```

### 1.2.7 数据切片 (data chunk)


# 2.tech
## 2.1 RAG
### 2.1.1 langchain (传统RAG，跨文档推理能力弱)
```
上传文档 --> 切片向量化 -->  存入向量库 --> 检索召回 --> 生成结果
```

### 2.1.2 LlamaIndex
### 2.1.2 LlamaGraph (需要事先建立知识图谱)

### 1.2.2 LLM wiki
```
https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
2026.04 Andrej Karpathy LLM Wiki 模式等想法，有些开源实现
github:
nashsu/llm_wiki
lucasastorian/llmwiki
inkeep/open-knowledge
Astro-Han/karpathy-llm-wiki
```

### 1.2.3 SAG (关系推理是核心)
https://github.com/Zleap-AI/SAG/
```
存储事件话，查询图谱画
```

###  1.2.99 其他
#### 1.2.99.1 WeKnora
https://github.com/Tencent/WeKnora

