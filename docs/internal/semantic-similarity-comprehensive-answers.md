# Semantic Similarity Layer — Complete Answer to All 7 Questions

---

## **Q1: What is Semantic Similarity Layer (Embedding-Based)?**

### **Definition**

A semantic similarity layer is a **fuzzy matching system** that finds conceptually similar terms even when exact words don't match.

### **How It Works — Simple Analogy**

Imagine you have these mapped terms in your alias map:
```
"mapping error payment id not found" → MAPPING ERROR - Payment ID Not Found
"payment id mismatch" → MAPPING ERROR - Data Format Issue
"tenancy settlement unsettled" → PARTIAL RECONCILED
```

A user asks: **"Why can't we match payment identifiers?"**

**Without semantic similarity:**
```
Is "why can't we match payment identifiers" in the alias map?
NO → return NOT_DEFINED ❌
```

**With semantic similarity:**
```
Is "why can't we match payment identifiers" in the alias map?
NO, but...
Is it SIMILAR to any mapped term?
  - Similarity to "mapping error payment id not found": 0.87 ✅ (close match!)
  - Similarity to "payment id mismatch": 0.82 ✅ (also close)
  - Similarity to "tenancy settlement": 0.15 ❌ (too different)

Take the highest match: "mapping error payment id not found"
Use that canonical term for explanation ✅
```

### **What "Embedding-Based" Means**

**Embedding:** A numerical representation of text. Think of it as converting words into a list of numbers that capture meaning.

```
"mapping error payment id" → [0.42, -0.18, 0.91, 0.03, -0.55, ...]
"why can't we match payment ids" → [0.39, -0.21, 0.88, 0.05, -0.58, ...]

Similarity score = measure how close these number sequences are
(cosine similarity, euclidean distance, etc.)
```

**Key insight:** Embeddings capture *meaning*, not just exact words. So:
- "payment identifier" and "payment ID" have high similarity
- "mapping error" and "id not found" are related, even though not identical words

---

## **Q2: Where Exactly Are We Adding Semantic Similarity Layer in the Existing System?**

### **Current System Architecture (Before)**

```
User Question
    ↓
Intent::IntentResolver.resolve(question)
    ├─ Pattern match: "what does {term} mean?"
    └─ Try all alias mappings
        ↓
        Result: Intent found OR nil
    ↓
ExplanationBuilder.explain(intent.term)
    ↓
    Result: ExplanationContract OR nil
    ↓
Follow-up Classifier (if nil)
    ↓
NOT_DEFINED (fallback)
```

### **New System Architecture (After Adding Semantic Layer)**

```
User Question
    ↓
Intent::IntentResolver.resolve(question)
    ├─ Pattern match: "what does {term} mean?"
    └─ Try all alias mappings
        ↓
        Result: Intent found OR nil
    ↓
    [If nil, enter semantic layer] ← NEW STEP
    Semantic::SemanticResolver.find_closest_alias(question)
    ├─ Encode question into embedding
    ├─ Find closest match in alias map embeddings
    └─ Return canonical term if similarity > 0.85
        ↓
        Result: Intent found OR nil
    ↓
ExplanationBuilder.explain(intent.term)
    ↓
    Result: ExplanationContract OR nil
    ↓
Follow-up Classifier (if nil)
    ↓
Layer 2: LLM Fallback (in demo app, not engine)
    ↓
NOT_DEFINED (final fallback)
```

### **Exact File Location**

**New file to create:**
```
lib/engine/intent/semantic_resolver.rb
```

**Update existing file:**
```
lib/engine/analyzer.rb  (line 75–95 in execute_pipeline)
```

**Current code location in analyzer.rb:**
```ruby
# Around line 160, in execute_pipeline:
unless result
  intent = Intent::IntentResolver.new.resolve(@question)
  # ← ADD SEMANTIC FALLBACK HERE
end
```

**What goes there:**
```ruby
unless result
  intent = Intent::IntentResolver.new.resolve(@question)
  
  # NEW: Semantic fallback if exact match failed
  unless intent
    semantic_intent = Intent::SemanticResolver.new.find_closest_alias(@question)
    intent = semantic_intent if semantic_intent
  end
end
```

---

## **Q3: What is Similarity Score?**

### **Definition**

A **similarity score is a number between 0 and 1** that measures how semantically similar two pieces of text are.

```
0.0 = completely different
0.5 = somewhat related
1.0 = identical or synonymous
```

### **Examples with Real Numbers**

```
Question: "Why can't we match payment identifiers?"

Comparing to alias map terms:

Term: "mapping error payment id not found"
Similarity: 0.91 ✅ HIGH (meaning, phrasing close)

Term: "payment id mismatch"
Similarity: 0.85 ✅ HIGH (related concept)

Term: "why is my payment missing"
Similarity: 0.78 ✓ MEDIUM (same domain, different angle)

Term: "how do I settle tenancy"
Similarity: 0.42 ❌ LOW (different concept)

Term: "what is the weather today"
Similarity: 0.05 ❌ VERY LOW (unrelated domain)
```

### **How Similarity is Calculated**

**Cosine Similarity** (most common):

```
embedding1 = [0.42, -0.18, 0.91, 0.03]  (question)
embedding2 = [0.39, -0.21, 0.88, 0.05]  (mapped alias)

similarity = (dot_product of vectors) / (magnitude1 × magnitude2)
           = 0.91  (ranges 0 to 1)
```

**Confidence Threshold:**

Your engine should use a threshold like **0.85** (or higher):
- If similarity ≥ 0.85 → Use this match ✅
- If similarity < 0.85 → Not confident enough, try next fallback

```ruby
SEMANTIC_CONFIDENCE_THRESHOLD = 0.85

if similarity_score >= SEMANTIC_CONFIDENCE_THRESHOLD
  return canonical_term  # Use this match
else
  return nil  # Keep looking
end
```

---

## **Q4: What Does "Find Closest Alias Using Embeddings" Mean?**

### **Step-by-Step Process**

**Step 1: Pre-compute embeddings for all alias map terms**

```
Alias Map:
  "mapping error payment id not found" → embedding: [0.42, -0.18, 0.91...]
  "payment id mismatch" → embedding: [0.40, -0.20, 0.89...]
  "tenancy settlement unsettled" → embedding: [0.15, 0.72, -0.33...]
  "partial reconciliation" → embedding: [0.18, 0.68, -0.31...]
  [... all other aliases ...]

Cached at startup, not recomputed each request.
```

**Step 2: User asks a question**

```
User: "Why can't we match payment identifiers?"
```

**Step 3: Encode user question into same embedding space**

```
User embedding: [0.41, -0.19, 0.90, 0.02...]
```

**Step 4: Compare user embedding to every alias embedding**

```
Distance to "mapping error..." = 0.91 ✅ CLOSEST
Distance to "payment id..." = 0.85 ✓ also close
Distance to "tenancy..." = 0.42 ❌ far
Distance to "partial..." = 0.40 ❌ far
```

**Step 5: Return the closest match**

```ruby
closest_alias = "mapping error payment id not found"
similarity_score = 0.91

if similarity_score >= 0.85
  # Use this term
  canonical_term = ALIAS_MAP[closest_alias]
  # → "MAPPING ERROR - Payment ID Not Found"
else
  # Not confident, fall through
  return nil
end
```

### **What "Finding Closest" Means in Code**

```ruby
def find_closest_alias(user_input)
  user_embedding = encode_text(user_input)
  
  best_match = nil
  best_score = 0
  
  CACHED_EMBEDDINGS.each do |alias_phrase, embedding|
    score = cosine_similarity(user_embedding, embedding)
    
    if score > best_score
      best_score = score
      best_match = alias_phrase
    end
  end
  
  if best_score >= SEMANTIC_CONFIDENCE_THRESHOLD
    return ALIAS_MAP[best_match]  # Return canonical term
  else
    return nil  # No close match found
  end
end
```

---

## **Q5: What Does "Demo Layer Adds LLM Fallback That Grounds Answers in Handbook Using RAG" Mean?**

### **RAG = Retrieval-Augmented Generation**

**RAG in simple terms:**

```
Question → [Retrieve relevant handbook sections] → [Pass to LLM] → Answer
```

### **Current Architecture (Engine Only)**

```
User: "Why can't we match payment identifiers?"
    ↓
Engine: "Not in my rules → NOT_DEFINED" ❌
    ↓
User: Still confused, no answer
```

### **With LLM Fallback (Demo Layer)**

```
User: "Why can't we match payment identifiers?"
    ↓
Engine: "Not in my rules → NOT_DEFINED"
    ↓
[Demo app catches NOT_DEFINED]
    ↓
LLM Fallback (RAG):
  1. Search handbook PDF for "payment ID", "matching", "error"
     → Find section: "Mapping errors occur when..."
  2. Pass to LLM with handbook context:
     Question: "Why can't we match payment identifiers?"
     Handbook context: [relevant paragraphs]
     System prompt: "You are explaining reconciliation to accountants..."
  3. LLM generates answer grounded in handbook
     → "Based on the handbook, mapping errors occur when..."
    ↓
Return answer to user ✅
```

### **Code Example (Demo App Layer, NOT Engine)**

```ruby
# app/services/reconciliation_assistant.rb
# This lives in the DEMO app, NOT in the engine

class ReconciliationAssistant
  def analyze(question:, session_id:)
    # Step 1: Try the deterministic engine
    engine_result = EngineClient.analyze(
      question: question,
      session_id: session_id
    )
    
    # Step 2: If engine says NOT_DEFINED, use LLM fallback
    if engine_result[:status] == "NOT_DEFINED"
      # RAG: Retrieve handbook sections
      handbook_context = retrieve_handbook_sections(question)
      
      # Generate answer using LLM + handbook
      llm_result = LLMClient.generate(
        question: question,
        handbook_context: handbook_context,
        system_prompt: BASE_SYSTEM_PROMPT
      )
      
      return {
        source: "llm_fallback",  # Traceability
        status: "SUCCESS",
        result: llm_result
      }
    end
    
    # Step 3: Engine answered, return that
    return {
      source: "deterministic_engine",  # Traceability
      status: engine_result[:status],
      result: engine_result[:result]
    }
  end
  
  private
  
  def retrieve_handbook_sections(question)
    # Use embeddings to find relevant handbook sections
    # (Could be simple full-text search or semantic search)
    handbook_pdf.search(question)
  end
end
```

### **Why This Architecture**

```
Engine layer:      Deterministic, auditable, no LLM, fast, cheap
   ↓
Demo layer:        Adds flexibility, uses LLM only when needed, tracks source
   ↓
Result:            "Best of both worlds" — governance + flexibility
```

---

## **Q6: Does Semantic Resolver and LLM Integration Needed Before Demo Rails App?**

### **SHORT ANSWER: NO — Different order is better**

### **Why?**

```
Engine is independent software.
Demo app is a consumer of the engine.
Building in wrong order creates coupling.
```

### **Correct Build Order**

```
Week 1:
  ✓ Repo 1 (Engine): COMPLETE (already done)
  
Week 2:
  ✓ Repo 2 (Demo): Build screens FIRST (seeds, models, Rails)
    - Upload screen (empty, no engine yet)
    - Display screen (static data)
    - Missing screen (static data)
    - Tenancy screen (static data)
    - Final screen (static data)
    
  ✓ Wire engine HTTP connection to demo
    - EngineClient.analyze in Rails
    - Basic integration test (no chat yet)
    
Week 3:
  ✓ Add semantic resolver to engine (optional enhancement)
  ✓ Add chat widget to demo (now engine is ready)
  
Week 4:
  ✓ Add LLM fallback to demo (separate from engine)
```

### **Why This Order Works**

**Problem with wrong order (semantic first):**
```
Build semantic resolver in engine
  ↓
Integrate into demo
  ↓
Demo is now blocked waiting for semantic layer to be perfect
  ↓
Both repos are tightly coupled
  ↓
Harder to iterate
```

**Right order (demo first):**
```
Build demo with static data + working screens
  ↓
Integrate basic engine (deterministic only)
  ↓
Confirm integration works
  ↓
THEN enhance engine with semantic layer
  ↓
Demo automatically gets the enhancement
  ↓
Repos stay loosely coupled
```

### **HOWEVER — One Dependency**

The demo Rails app **does need** to handle engine responses with a fallback structure:

```ruby
# In Rails, be prepared for:
result = Engine::Analyzer.analyze(question)

case result[:status]
when "SUCCESS"
  # Display the explanation
when "NOT_DEFINED"
  # Show "We couldn't find that" message
  # (Semantic resolver would be checked here)
when "ENGINE_UNAVAILABLE"
  # Show "Engine is down" message
end
```

This means: **Build the integration interface** in demo first, then the engine can be enhanced without demo changes.

---

## **Q7: Should Semantic Similarity Layer Be Ruby or Python? How to Wire?**

### **ANSWER: Ruby for now, with Python optional later**

### **Option A: Ruby Implementation (Recommended for Now)**

**Pros:**
- ✅ Stays in same codebase (engine is all Ruby)
- ✅ No inter-process communication needed
- ✅ Simpler deployment
- ✅ Easier to debug

**Cons:**
- ❌ Ruby embedding libraries are slower than Python
- ❌ Less mature ML ecosystem

**Implementation:**

```ruby
# Gemfile
gem 'ruby-vips'  # For performance
gem 'similarity'  # Cosine similarity
# OR
gem 'gensim'  # Ruby binding to Python gensim (if you want)

# lib/engine/intent/semantic_resolver.rb
module Engine
  module Intent
    class SemanticResolver
      # Option 1: Use pre-computed embeddings (simplest)
      CACHED_EMBEDDINGS = load_embeddings_from_yaml
      
      def find_closest_alias(user_input)
        # Encode question
        user_embedding = encode_with_openai_api(user_input)
        # Or use local model:
        user_embedding = encode_with_local_model(user_input)
        
        # Find closest
        best_match = find_max_similarity(
          user_embedding,
          CACHED_EMBEDDINGS
        )
        
        # Return if confident
        return best_match if best_match[:score] >= 0.85
        nil
      end
    end
  end
end
```

---

### **Option B: Python Microservice (Better for Scale)**

**Pros:**
- ✅ Much faster embeddings
- ✅ Better ML libraries (scikit-learn, numpy)
- ✅ Easy to swap models
- ✅ Scales independently

**Cons:**
- ❌ Requires inter-process communication
- ❌ More complex deployment
- ❌ Two languages to manage

**Architecture (if you choose this):**

```
Ruby Engine
    ↓
HTTP call to Python microservice
    ↓
/api/semantic-match endpoint
    ↓
Python calculates similarity
    ↓
Returns best match
    ↓
Ruby engine uses the result
```

**Ruby side (calling Python service):**

```ruby
# lib/engine/intent/semantic_resolver.rb
module Engine
  module Intent
    class SemanticResolver
      SIMILARITY_SERVICE_URL = ENV.fetch(
        "SIMILARITY_SERVICE_URL",
        "http://localhost:5000"
      )
      
      def find_closest_alias(user_input)
        response = HTTParty.post(
          "#{SIMILARITY_SERVICE_URL}/find-similar",
          body: {
            question: user_input,
            threshold: 0.85
          }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        
        result = JSON.parse(response.body, symbolize_names: true)
        return result[:canonical_term] if result[:found]
        nil
      end
    end
  end
end
```

**Python side (flask microservice):**

```python
# similarity_service/app.py
from flask import Flask, request, jsonify
from sentence_transformers import SentenceTransformer, util

app = Flask(__name__)
model = SentenceTransformer('all-MiniLM-L6-v2')

# Pre-load and encode all alias map terms
ALIAS_MAP = load_alias_map_from_yaml()
CACHED_EMBEDDINGS = {
    alias: model.encode(alias)
    for alias in ALIAS_MAP.keys()
}

@app.route('/find-similar', methods=['POST'])
def find_similar():
    data = request.json
    question = data['question']
    threshold = data.get('threshold', 0.85)
    
    # Encode question
    question_embedding = model.encode(question)
    
    # Find closest
    best_match = None
    best_score = 0
    
    for alias, embedding in CACHED_EMBEDDINGS.items():
        score = util.pytorch_cos_sim(
            question_embedding,
            embedding
        ).item()
        
        if score > best_score:
            best_score = score
            best_match = alias
    
    if best_score >= threshold:
        return jsonify({
            'found': True,
            'canonical_term': ALIAS_MAP[best_match],
            'score': best_score
        })
    else:
        return jsonify({
            'found': False,
            'score': best_score
        })

if __name__ == '__main__':
    app.run(port=5000)
```

### **My Recommendation**

**Phase 1 (this month):** Ruby only, use OpenAI embeddings API
```
Simple, no new languages, use existing engine
Cost: ~$0.01 per query (embedding API call)
Speed: 200ms per question
```

**Phase 2 (next month):** Python microservice if needed
```
If you need faster, cheaper processing
Add Python service as sidecar
Ruby calls it via HTTP
```

---

## **Q8: What is the Hybrid Architecture (2-Layer Fallback)?**

### **The 2-Layer Fallback System (Complete)**

```
LAYER 1: Deterministic Engine (Always Tried First)
├─ Exact Intent Resolution (pattern + alias map)
├─ Semantic Similarity (find closest alias)
├─ Knowledge Eligibility Gate (can we answer?)
├─ Template-Based Explanation (use templates)
└─ Follow-up Projection (answer follow-ups)

    IF Layer 1 returns result → USE IT ✅
    IF Layer 1 returns NOT_DEFINED → Continue to Layer 2

LAYER 2: LLM Fallback (Used Only When Needed)
├─ Retrieve handbook sections (search PDF)
├─ Query LLM with handbook context
├─ Generate grounded answer
└─ Mark source as "llm_fallback" for traceability

    IF Layer 2 succeeds → USE IT ✅
    IF Layer 2 fails → Return NOT_DEFINED ❌
```

### **Visual Diagram**

```
┌─────────────────────────────────────────────────────────┐
│                    USER QUESTION                        │
│            "Why can't we match payment IDs?"            │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────────┐
        │   LAYER 1: Deterministic Engine  │
        └──────────────┬───────────────────┘
                       │
          ┌────────────┴────────────┐
          │                         │
    Pass 1: Exact Match        Pass 2: Semantic Match
    (Alias Map)               (Embeddings)
          │                         │
          ▼                         ▼
    Found? NO                Found? YES (score 0.91)
          │                    ↓
          │            use "mapping error payment..."
          │                    ↓
          ├────────────────────┘
          │
    Pass 3: Knowledge Eligibility Gate
          │
          ▼
    Allowed to answer? YES
          │
          ▼
    ExplanationBuilder
          │
          ▼
    ✅ Return ExplanationContract (STOP HERE)
    
    
    IF NO match found in Layer 1:
          │
          ▼
    ┌──────────────────────────────────┐
    │  LAYER 2: LLM Fallback (Demo App)│
    └──────────────┬───────────────────┘
                   │
              RAG Pipeline:
              1. Search handbook
              2. Retrieve sections
              3. Pass to LLM
              4. Generate answer
                   │
                   ▼
          Answer found? YES/NO
                   │
                   ▼
    ✅ Return LLM Answer OR NOT_DEFINED (FINAL)
```

---

## **Before & After Visualization**

### **Before: Only Exact Matching (Current)**

```
User: "What does mapping error payment ID not found mean?"
  ↓
Exact match in alias map? YES
  ↓
✅ Returns explanation immediately (0.1 seconds)

────────────────────────────────────────────────────────────

User: "Why can't we match payment identifiers?"
  ↓
Exact match in alias map? NO
  ↓
❌ Returns NOT_DEFINED (user confused)
```

### **After: 2-Layer Hybrid (With Semantic + LLM)**

```
User: "What does mapping error payment ID not found mean?"
  ↓
Layer 1 Exact match? YES
  ↓
✅ Returns explanation immediately (0.1 seconds)
   [Source: deterministic_engine]

────────────────────────────────────────────────────────────

User: "Why can't we match payment identifiers?"
  ↓
Layer 1 Exact match? NO
  ↓
Layer 1 Semantic match (similarity 0.91)? YES
  ↓
✅ Returns explanation for "mapping error..." (0.3 seconds)
   [Source: semantic_resolver]

────────────────────────────────────────────────────────────

User: "What should we do if we have unmatched transactions?"
  ↓
Layer 1 Exact match? NO
  ↓
Layer 1 Semantic match? NO (score 0.72, below 0.85 threshold)
  ↓
Layer 2: LLM Fallback activates
  1. Search handbook for "unmatched transactions"
  2. Retrieve 2-3 relevant sections
  3. Pass to LLM: "Based on handbook, answer this:"
  ↓
✅ Returns LLM-generated answer (1.5 seconds)
   [Source: llm_fallback_rag]

────────────────────────────────────────────────────────────

User: "Can I use reconciliation on Mars?"
  ↓
Layer 1: NO match
Layer 2: Handbook has no Mars content
         LLM also can't ground answer
  ↓
❌ Returns NOT_DEFINED (final fallback)
   [Source: not_defined]
```

### **Comparison Table**

| Question Type | Before (Current) | After (2-Layer Hybrid) | Speed | Cost |
|---|---|---|---|---|
| Exact alias match | ✅ 0.1s | ✅ 0.1s | Same | Same |
| Semantic variant | ❌ NOT_DEFINED | ✅ 0.3s | Slower | +embedding API |
| Novel question | ❌ NOT_DEFINED | ✅ 1.5s | Slow | +LLM API |
| Out of domain | ❌ NOT_DEFINED | ❌ NOT_DEFINED | Same | Same |

---

## **Summary: The Complete Picture**

### **What You're Building**

```
Deterministic Layer      → Fast, auditable, governance-focused
    ↓
Semantic Similarity      → Handles natural phrasing variations
    ↓
LLM Fallback (Demo)      → Handles novel questions
    ↓
= Production-grade AI System
```

### **Timeline**

```
Week 1: ✅ Complete engine (done)
Week 2: Build demo Rails app + basic integration
Week 3: Add semantic resolver to engine (optional)
Week 4: Add LLM fallback to demo app
Week 5: Deploy and record demo
```

### **Architecture Principle**

```
Engine = Pure Logic (no LLM)
Demo = Smart UI Layer (adds LLM)
Separation = Clean, testable, auditable
```

This is **senior-level system design for financial AI**.

---

## **Next Action**

Given your current state:
1. ✅ Fix the Canonicalizer.call() bug in analyzer.rb (one-line fix)
2. ✅ Test engine works end-to-end via Docker
3. ⏳ Start demo Rails app (Week 2)
4. ⏳ Wire engine HTTP integration (Week 2-3)
5. ⏳ Add semantic resolver if time permits (Week 3)
6. ⏳ Add LLM fallback in demo (Week 4)

You're on the right track. The engine is solid. Now focus on the Rails demo.
