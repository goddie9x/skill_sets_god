---
name: humanize-content
description: >-
  Write or rewrite reader-facing content (articles, blog posts, web copy,
  social posts, guides) so it reads like a specific person wrote it, not
  like AI output: ban AI vocabulary and template structures, vary sentence
  rhythm, require concrete detail, a real opinion, and a trade-off, and
  never invent facts. Use ONLY when the user explicitly asks to write,
  rewrite, draft, or humanize content. Do NOT apply to code, code review,
  commit messages, short chat replies, or any task where the user did not
  ask for content writing.
---

# Humanize content

Readers do not catch AI writing from one word. They catch it because no
person stands behind the text: no lived experience, no willingness to
commit to a claim, no detail only an insider would know. A word blacklist
alone does not fix that. A model told never to say one word says a
synonym in the same dead rhythm. The tells that matter are structural,
rhythmic, and substantive, so the fixes below constrain how the text is
built, not just which words it uses.

A detector score is not the goal. Detectors err in both directions,
especially for writers working in a second language. The goal is a piece
a reader trusts because a specific person is visibly behind it. Where a
destination requires AI disclosure (school, newsroom, contest), disclose.
This skill improves writing quality; it is not a way to hide AI use where
disclosure is required.

## When to use

Only when the user explicitly asks to write, rewrite, draft, edit, or
humanize reader-facing content. Trigger phrases include "write an
article/post/copy/guide", "rewrite this draft", "make this sound human",
and the Vietnamese equivalents: "viết bài", "viết content", "viết lại
cho tự nhiên".

## When NOT to use

- Code, code review, commit messages, code comments, terminal output.
- Short chat replies, explanations, and answers that are not content.
- Any task where the user did not ask for content writing. Never
  re-police other skills' outputs or ordinary replies against these
  rules. A chat reply is allowed to be a chat reply.
- Do not bake one site's house rules into every piece. Project-specific
  add-ons (a CMS renderer, link rules, a style sheet) live with the
  project and compose with this skill when that project is the target.

## Before writing

Use what the user gave you: real details, numbers they measured, mistakes
they made, their opinion, a voice sample. A voice sample teaches sentence
length, pronouns, and address; never copy its content. If the user gave
no real detail, do not invent any. Write from checkable facts, and flag
the gaps after the piece (see "Two passes").

## Banned vocabulary

English, banned outright: delve, tapestry, realm, landscape, intricate,
pivotal, crucial, underscore, foster, testament, nuanced, comprehensive,
vibrant, robust, meticulous, leverage, harness, embark, beacon, enhance,
seamless, transformative, groundbreaking, game-changer, paradigm, synergy,
empower, streamline, elevate, unlock, unleash, holistic, multifaceted,
cutting-edge, showcasing, moreover, furthermore, additionally,
"in conclusion", "it is important to note", "in today's fast-paced
world", "dive into", "navigate the challenges", "unlock the potential",
"a testament to", "rich tapestry".

Vietnamese, banned outright: "trong thời đại công nghệ 4.0", "trong bối
cảnh... hiện nay", "hãy cùng tìm hiểu", "cùng khám phá", "đóng vai trò
then chốt", "chìa khóa thành công", "hành trình", "bức tranh toàn cảnh",
"không thể phủ nhận", "đào sâu vào", "điều hướng những thách thức",
"mở khóa tiềm năng", "nâng tầm", "chắc chắn rồi", "câu hỏi rất hay",
"hy vọng bài viết hữu ích với bạn", "tóm lại", "kết luận lại",
"nói tóm lại".

Use sparingly, only when removing the word weakens the sentence: thực sự,
vô cùng, cực kỳ, hoàn toàn, "có thể nói rằng", "nhìn chung", "ở một mức
độ nào đó". Do not open several consecutive paragraphs with "bên cạnh
đó", "ngoài ra", "hơn thế nữa". Let the next idea connect to the previous
one through its content.

Prefer the plain verb: use, build, show, fix, run. If you would never say
a word out loud to a coworker, do not write it.

## Banned structures

- The em dash as a universal connector for asides. Vietnamese: do not
  use it. English: at most once in a long piece. Use a comma, parentheses,
  or split the sentence.
- Lists of exactly three parallel adjectives or nouns, repeated
  ("fast, efficient, and affordable"). Two ideas means two, four means
  four, or write a full sentence.
- The strawman frame: "not X but Y", "not just X, it is Y", "không phải
  X mà là Y", "không chỉ X mà còn Y". State Y directly, then prove it.
- Asking a question and answering it yourself: at most once per piece.
- A closing punchline at the end of every paragraph restating what was
  just said ("And that is the power of..."). Delete it; the paragraph
  usually improves.
- False balance: ending every issue with "pros and cons, it depends on
  your needs". When the evidence supports a side, take it, give the
  reason, and say when the other side is the right choice.
- Era openers, discovery invitations, and textbook definitions at the
  start. Open with a concrete detail, a real problem, or an opinion.
- A summary ending that repeats every point. End with a concrete next
  action, a warning, or stop when the ideas run out. Short pieces need
  no conclusion section.

## Rhythm

Mix short sentences (3 to 8 words), medium ones, and long ones. Never
let three consecutive sentences run about the same length. Vary paragraph
length too: some paragraphs are one or two sentences, some are five or
six. Let a section run long when it has a lot to say and stay short when
it does not. Do not force sections to balance. A real writer has a
three-word sentence and a three-line sentence in the same piece.

## Substance: a person must stand behind the text

Every piece needs at least two concrete details (a number, a name, a
date, a step taken, an error encountered), one opinion with its reason,
and one downside, limit, or trade-off. Attribute claims to named sources.
Never write "many experts say", "studies show", or "a large company"
without naming who. Apply the specificity test to each sentence: if the
sentence still reads fine in someone else's piece on a different topic,
it says nothing. Rewrite it so it belongs only to this piece, or delete
it.

## Vietnamese naturalness

When writing Vietnamese from an English source or an English idea:
understand the meaning, close the source, and write fresh as if
explaining to a friend. Never translate sentence by sentence. Every
sentence must pass the read-aloud test: it sounds like a Vietnamese
person wrote it. Correct grammar is not enough; it must sound natural
when spoken.

Avoid English-shaped sentences: excess passive "bị" and "được",
nominalization with "việc" and "sự" where a verb is shorter, and
showy Sino-Vietnamese words where a plain Vietnamese word exists.
Banned literal-translation patterns: "Hãy biết... bằng cách", "nghe
như:" followed by a quote, "nghĩa là chú ý", "mà không ai hỏi" (for
unprompted), "không cần xin lỗi" (for unapologetic), "hướng về" (for
turning toward), "làm phần lớn việc", "bắt đầu rẻ", "Trong các nghiên
cứu" (for research), and a trailing ", một cách..." clause hanging at
the end of a sentence. Do not use regional or teen words: hông, nè, nha.
Vietnamese headings use sentence case ("Cách để viết tốt hơn"), not
English-style capitalization of every word.

English pieces get the same standard in reverse: write like a person
talking, not in the Wikipedia voice of perfect grammar, flat affect, and
abstractions that could describe anything.

## Presentation restraint

Bold at most one phrase per paragraph, only when a skimming reader needs
to catch it. Do not repeat bold-label-plus-colon bullets through a whole
piece. Bullets and tables serve lookup, comparison, or steps; if the
content does not need them, write prose. No emoji in headings of a
serious piece. No "Introduction", "Main content", "Conclusion" sections
in a short piece.

## Never fabricate

Never invent statistics, quotes, names, personal stories, or measured
results. Numbers come from the user or from a checkable source, with the
source named or the figure marked as an estimate. Experience stories
come only from information the user supplied. Where real detail is
missing, note it after the piece instead of inventing it inside the
piece.

## Two passes

Pass 1: write the draft. Pass 2: read 100% of it, sentence by sentence,
never a sample, and fix every banned word, every generic sentence, every
even stretch of rhythm, and every translated-sounding line. Deliver only
the final version. After the piece, in a separate "Notes for the writer"
section of at most 5 lines, list where the user should add real detail
and which figures need re-checking. No assistant greeting, no explanation
of the process, no "Here is the article".

## De-AI pass for an existing draft

When the user hands you a draft that reads like AI:

1. Diagnose first. List the tells found, quoting the exact sentences,
   in four groups: words and phrases; sentence and paragraph structure;
   generic or detail-free content; presentation. Include the Vietnamese
   translationese checks when the draft is Vietnamese.
2. Rewrite the whole draft: straight to the point, mixed sentence
   lengths, uneven paragraphs, the author's opinion stated plainly,
   every concrete detail of the original kept, empty sentences deleted,
   the summary ending removed when the piece is already clear.
3. Preserve all facts, figures, order of ideas, and opinions. Add no
   new statistics, quotes, or stories the draft did not contain.
4. Return, in order: the list of tells, the full rewrite, and at most
   5 lines of notes on where the author should add real detail and what
   the most important change was.

## Sources

- https://boxxv.github.io/2026/11/14/viet-tot-hon-3-tranh-giong-van-ai-va-lo-trinh/
- https://www.aiwithadele.com/guides/ai-writing-tells
- https://justdone.com/blog/writing/how-to-tell-if-something-is-written-by-ai
- https://speedwrite.com/signs-of-ai-writing
- https://github.com/openadaptai/openadapt-herald/blob/HEAD/herald/prompts/writing_guide.md
- https://www.rewritica.com/blog/signs-of-ai-writing
- https://stephublabs.com/blog/complete-guide-humanizing-ai-writing-prompt-system/
