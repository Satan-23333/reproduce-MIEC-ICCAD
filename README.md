# MEIC : Make Each Iteration Count.  <h3><p align="right">*Verilog auto debug with LLMs*</p></h3>
This repository contains artefacts and workflows to reproduce experiments from the ICCAD 2024 paper   

**"MEIC: Re-thinking RTL Debug Automation using LLMs"**
## Directory Overview
- ErrorSet: The dataset we use, which contains error codes.
- Framework: Contains the main program `main.py`, along with other necessary script files and configuration files.

## How to Use
- Install the ModelSim simulation tool.
- Install dependencies:
```bash
  pip install -r requirements.txt
```
- Modify the contents of ```Framework/api.ini``` to include your own OpenAI API key.
- Modify the contents of ```Framework/config.json```, paying attention to the configuration file paths.
- Run ```Framework/main.py```. The script will automatically generate an output folder, save logs, and count the output results.

## Author
**Ke Xu, Jialin Sun, Yuchen Hu, Xinwei Fang, Weiwei Shan, Xi Wang and Zhe Jiang**  
*National Center of Technology Innovation for EDA, School of Integrated Circuits, Southeast University, China*  
*Department of Computer Science, University of York, UK*
## Reference  
[1]	Baleegh Ahmad, Shailja Thakur, Benjamin Tan, Ramesh Karri, and Hammond Pearce. 2023. Fixing hardware security bugs with large language models. arXiv preprint arXiv:2302.01215 (2023).  
[2]	Xavier Amatriain. 2024. MEASURING AND MITIGATING HALLUCINATIONS IN LARGE LANGUAGE MODELS: AMULTIFACETED APPROACH. (2024).  
[3]	Jason Blocklove, Siddharth Garg, Ramesh Karri, and Hammond Pearce. 2023. Chip-Chat: Challenges and Opportunities in Conversational Hardware Design. arXiv preprint arXiv:2305.13243 (2023).  
[4]	Kaiyan Chang, Ying Wang, Haimeng Ren, Mengdi Wang, Shengwen Liang, Yinhe Han, Huawei Li, and Xiaowei Li. 2023. ChipGPT: How far are we from natural language hardware design. arXiv preprint arXiv:2305.14019 (2023).  
[5]	Mark Chen, Jerry Tworek, Heewoo Jun, Qiming Yuan, Henrique Ponde de Oliveira Pinto, Jared Kaplan, Harri Edwards, Yuri Burda, Nicholas Joseph, Greg Brockman, et al. 2021. Evaluating large language models trained on code. arXiv preprint arXiv:2107.03374 (2021).  
[6]	Yuyan Chen, Qiang Fu, Yichen Yuan, Zhihao Wen, Ge Fan, Dayiheng Liu, Dong-mei Zhang, Zhixu Li, and Yanghua Xiao. 2023. Hallucination detection: Robustly discerning reliable answers in large language models. In Proceedings of the 32nd ACM International Conference on Information and Knowledge Management. 245–255.  
[7]	Shivakumar S Chonnad and Needamangalam B Balachander. 2007. Verilog: Frequently Asked Questions: Language, Applications and Extensions. Springer Science & Business Media.  
[8]	Clayton Cohn, Nicole Hutchins, Tuan Le, and Gautam Biswas. 2024. A Chain-of-Thought Prompting Approach with LLMs for Evaluating Students’ Formative Assessment Responses in Science. In Proceedings of the AAAI Conference on Artificial Intelligence, Vol. 38. 23182–23190.  
[9]	Matthew DeLorenzo, Animesh Basak Chowdhury, Vasudev Gohil, Shailja Thakur, Ramesh Karri, Siddharth Garg, and Jeyavijayan Rajendran. 2024. Make Every Move Count: LLM-based High-Quality RTL Code Generation Using MCTS. arXiv preprint arXiv:2402.03289 (2024).  
[10]	Sarah Fakhoury, Aaditya Naik, Georgios Sakkas, Saikat Chakraborty, and Shu-vendu K. Lahiri. 2024. LLM-based Test-driven Interactive Code Generation: User Study and Empirical Evaluation. arXiv:2404.10100 [cs.SE]  
[11]	Wenji Fang, Mengming Li, Min Li, Zhiyuan Yan, Shang Liu, Hongce Zhang, and Zhiyao Xie. 2024. AssertLLM: Generating and Evaluating Hardware Veri-fication Assertions from Design Specifications via Multi-LLMs. arXiv preprint arXiv:2402.00386 (2024).  
[12]	Shangbin Feng, Weijia Shi, Yike Wang, Wenxuan Ding, Vidhisha Balachandran, and Yulia Tsvetkov. 2024. Don’t Hallucinate, Abstain: Identifying LLM Knowledge Gaps via Multi-LLM Collaboration. arXiv preprint arXiv:2402.00367 (2024).  
[13]	Weimin Fu, Kaichen Yang, Raj Gautam Dutta, Xiaolong Guo, and Gang Qu. 2023. LLM4SecHW: Leveraging domain-specific large language model for hard-ware debugging. In 2023 Asian Hardware Oriented Security and Trust Symposium (AsianHOST). IEEE, 1–6.  
[14]	Boris A Galitsky. 2023. Truth-o-meter: Collaborating with llm in fighting its hallucinations. (2023).  
[15]	Emil Goh, Maoyang Xiang, I Wey, T Hui Teo, et al. 2024. From English to ASIC: Hardware Implementation with Large Language Model. arXiv preprint arXiv:2403.07039 (2024).  
[16]	Muhammad Hassan, Sallar Ahmadi-Pour, Khushboo Qayyum, Chandan Kumar Jha, and Rolf Drechsler. [n. d.]. LLM-guided Formal Verification Coupled with Mutation Testing. ([n. d.]).  
[17]	Ziwei Ji, Tiezheng Yu, Yan Xu, Nayeon Lee, Etsuko Ishii, and Pascale Fung. 2023. Towards mitigating LLM hallucination via self reflection. In Findings of the Association for Computational Linguistics: EMNLP 2023. 1827–1843.  
[18]	Xue Jiang, Yihong Dong, Lecheng Wang, Zheng Fang, Qiwei Shang, Ge Li, Zhi Jin, and Wenpin Jiao. 2023. Self-planning Code Generation with Large Language Models. arXiv:2303.06689 [cs.SE]  
[19]	Zhe Jiang, Shuai Zhao, Ran Wei, Dawei Yang, Richard Paterson, Nan Guan, Yan Zhuang, and Neil C Audsley. 2021. Bridging the pragmatic gaps for mixed-criticality systems in the automotive industry. IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems 41, 4 (2021), 1116–1129.  
[20]	Kevin Laeufer, Brandon Fajardo, Abhik Ahuja, Vighnesh Iyer, Borivoje Nikolić, and Koushik Sen. 2024. RTL-Repair: Fast Symbolic Repair of Hardware Design Code. In Proceedings of the 29th ACM International Conference on Architectural Support for Programming Languages and Operating Systems, Volume 3. 867–881.  
[21]	Sakari Lahti, Panu Sjövall, Jarno Vanne, and Timo D Hämäläinen. 2018. Are we there yet? A study on the state of high-level synthesis. IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems 38, 5 (2018), 898–911.  
[22]	Mingjie Liu, Teodor-Dumitru Ene, Robert Kirby, Chris Cheng, Nathaniel Pinck-ney, Rongjian Liang, Jonah Alben, Himyanshu Anand, Sanmitra Banerjee, Ismet Bayraktaroglu, et al. 2023. Chipnemo: Domain-adapted llms for chip design. arXiv preprint arXiv:2311.00176 (2023).  
[23]	Mingjie Liu, Nathaniel Pinckney, Brucek Khailany, and Haoxing Ren. 2023. Ver-ilogeval: Evaluating large language models for verilog code generation. In 2023 IEEE/ACM International Conference on Computer Aided Design (ICCAD). IEEE, 1–8.   
[24]	Raoni Lourenço, Juliana Freire, Eric Simon, Gabriel Weber, and Dennis Shasha. 2023. BugDoc: Iterative debugging and explanation of pipeline. The VLDB Journal 32, 1 (2023), 75–101.  
[25]	Yao Lu, Shang Liu, Qijun Zhang, and Zhiyao Xie. 2023. RTLLM: An open-source benchmark for design rtl generation with large language model. arXiv preprint arXiv:2308.05345 (2023).  
[26]	Daye Nam, Andrew Macvean, Vincent Hellendoorn, Bogdan Vasilescu, and Brad Myers. 2024. Using an llm to help with code understanding. In Proceedings of the IEEE/ACM 46th International Conference on Software Engineering. 1–13.  
[27]	OpenAI. 2024. ChatGPT - Fine-Tuning. https://platform.openai.com/docs/guides/fine-tuning  
[28]	Soumen Pal, Manojit Bhattacharya, Sang-Soo Lee, and Chiranjib Chakraborty. 2024. A domain-specific next-generation large language model (LLM) or Chat-GPT is required for biomedical engineering and research. Annals of Biomedical Engineering 52, 3 (2024), 451–454.  
[29]	S Ramachandran. 2007. RTL Coding Guidelines. Digital VLSI Systems Design: A Design Manual for Implementation of Projects on FPGAs and ASICs Using Verilog (2007), 187–214.  
[30]	Pranab Sahoo, Ayush Kumar Singh, Sriparna Saha, Vinija Jain, Samrat Mondal, and Aman Chadha. 2024. A Systematic Survey of Prompt Engineering in Large Language Models: Techniques and Applications. arXiv preprint arXiv:2402.07927 (2024).  
[31]	SEIMENS. 2024. ModelSim. https://eda.sw.siemens.com/en-US/ic/modelsim/  
[32]	Priya Srikumar. 2023. Fast and wrong: The case for formally specifying hardware with LLMS. In Proceedings of the International Conference on Architectural Support for Programming Languages and Operating Systems (ASPLOS). ACM. ACM Press.  
[33]	Stuart Sutherland. 2000. The IEEE Verilog 1364-2001 Standard What’s New, and Why You Need It. In 9th Internatioinal HDL Conference (HDLCon).  
[34]	Stuart Sutherland and Don Mills. 2010. Verilog and SystemVerilog Gotchas: 101 Common Coding Errors and How to Avoid Them. Springer Science & Business Media.  
[35]	Shailja Thakur, Baleegh Ahmad, Zhenxing Fan, Hammond Pearce, Benjamin Tan, Ramesh Karri, Brendan Dolan-Gavitt, and Siddharth Garg. 2023. Benchmarking large language models for automated verilog rtl code generation. In 2023 Design, Automation & Test in Europe Conference & Exhibition (DATE). IEEE, 1–6.  
[36]	Shailja Thakur, Baleegh Ahmad, Hammond Pearce, Benjamin Tan, Brendan Dolan-Gavitt, Ramesh Karri, and Siddharth Garg. 2023. Verigen: A large language model for verilog code generation. arXiv preprint arXiv:2308.00708 (2023).  
[37]	Runchu Tian, Yining Ye, Yujia Qin, Xin Cong, Yankai Lin, Zhiyuan Liu, and Maosong Sun. 2024. Debugbench: Evaluating debugging capability of large language models. arXiv preprint arXiv:2401.04621 (2024).  
[38]	YunDa Tsai, Mingjie Liu, and Haoxing Ren. 2023. RTLFixer: Automatically Fixing RTL Syntax Errors with Large Language Models. arXiv preprint arXiv:2311.16543 (2023).  
[39]	Lily Jiaxin Wan, Yingbing Huang, Yuhong Li, Hanchen Ye, Jinghua Wang, Xiaofan Zhang, and Deming Chen. 2024. Software/Hardware Co-design for LLM and Its Application for Design Verification. In 2024 29th Asia and South Pacific Design Automation Conference (ASP-DAC). IEEE, 435–441.  
[40]	Jason Wei, Xuezhi Wang, Dale Schuurmans, Maarten Bosma, Fei Xia, Ed Chi, Quoc V Le, Denny Zhou, et al. 2022. Chain-of-thought prompting elicits reason-ing in large language models. Advances in neural information processing systems 35 (2022), 24824–24837.  
[41]	Ran Wei, Zhe Jiang, Xiaoran Guo, Haitao Mei, Athanasios Zolotas, and Tim Kelly. 2022. Designing critical systems with iterative automated safety analysis. In Proceedings of the 59th ACM/IEEE Design Automation Conference. 181–186.  
[42]	Ran Wei, Zhe Jiang, Xiaoran Guo, Ruizhe Yang, Haitao Mei, Athanasios Zolotas, and Tim Kelly. 2023. DECISIVE: Designing Critical Systems With Iterative Automated Safety Analysis. IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems (2023).  
[43]	Jules White, Quchen Fu, Sam Hays, Michael Sandborn, Carlos Olea, Henry Gilbert, Ashraf Elnashar, Jesse Spencer-Smith, and Douglas C Schmidt. 2023. A prompt pattern catalog to enhance prompt engineering with chatgpt. arXiv preprint arXiv:2302.11382 (2023).  
[44]	Henry Wong. 2019. HDLBits - Practice FPGA Problems. https://hdlbits.01xz. net/wiki/Main_Page  
[45]	Tongshuang Wu, Michael Terry, and Carrie Jun Cai. 2022. Ai chains: Transparent and controllable human-ai interaction by chaining large language model prompts. In Proceedings of the 2022 CHI conference on human factors in computing systems. 1–22.  
[46]	Xufeng Yao, Haoyang Li, Tsz Ho Chan, Wenyi Xiao, Mingxuan Yuan, Yu Huang, Lei Chen, and Bei Yu. 2024. HDLdebugger: Streamlining HDL debugging with Large Language Models. arXiv preprint arXiv:2403.11671 (2024).  
[47]	JD Zamfirescu-Pereira, Richmond Y Wong, Bjoern Hartmann, and Qian Yang. 2023. Why Johnny can’t prompt: how non-AI experts try (and fail) to design LLM prompts. In Proceedings of the 2023 CHI Conference on Human Factors in Computing Systems. 1–21.  
[48]	Yue Zhang, Yafu Li, Leyang Cui, Deng Cai, Lemao Liu, Tingchen Fu, Xinting Huang, Enbo Zhao, Yu Zhang, Yulong Chen, et al. 2023. Siren’s song in the ai ocean: A survey on hallucination in large language models. arXiv preprint arXiv:2309.01219 (2023).
