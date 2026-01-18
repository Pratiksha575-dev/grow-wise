# GrowWise
**AI-Powered Task Assistant for Holistic Child Development & Sustainable Parenting**

## Overview
GrowWise is a Flutter-based mobile application that generates **daily AI-driven tasks** for **children and parents** to support emotional, physical, social, cognitive, and ethical development.  
The system uses **local AI (LLM via Ollama)**, ensuring privacy, offline-first behavior, and responsible AI usage.

---

## Core Features
- AI-generated **5 daily tasks** per user
- Balanced task domains: Emotional, Physical, Social, Cognitive, Ethical
- Separate AI logic for **Children** and **Parents**
- Task interactions: Complete, Like, Skip
- Visual progress tracking for both parent and child
- Offline-first local data storage

---

## Tech Stack
- **Frontend:** Flutter (Dart)
- **State Management:** Provider
- **AI Engine:** Local LLM via Ollama
- **Prompt Engineering:** Structured prompts with domain enforcement
- **Database:** Hive (Local NoSQL)

---

## AI Setup (Required)  for Running application.

GrowWise uses **Ollama running locally**.

### 1. Install and Run Ollama
```bash
ollama serve
ollama pull mistral:7b-instruct
```
### 2. Emulator vs Physical Device URL Setup for
- Android Emulator
  Use:http://10.0.2.2:11434
- Physical Android Device (using USB):
```bash 
adb reverse tcp:11434 tcp:11434
```
Then use: http://localhost:11434
- If multiple devices are connected:
```bash
adb -s <device_id> reverse tcp:11434 tcp:11434
```
Apart from this URL configuration, no other setup is required.  
The application runs fully offline once Ollama is accessible.

----
How It Works (High Level)

- User opens the app (Parent or Child view)

- App checks if today’s tasks already exist

- AI prompt is built using profile and past behavior

- Local LLM generates tasks

- Output is validated and stored locally

- UI displays tasks and progress
-----
## Responsible AI Notes
- No external APIs are used

- No personal data leaves the device

- AI assists decision-making, does not replace parenting

- Structured output prevents unsafe or irrelevant content

## Project Context

- Internship: 1M1B – AI for Sustainability
- Primary SDG: SDG 3 – Good Health & Well-Being

## Author
Pratiksha Zodge  
B.E. Computer Engineering (T.E)   
Smt. Indira Gandhi College of Engineering (SIGCE)  






