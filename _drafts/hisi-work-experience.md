# 海思工作回顾

2013回忆：
  REN验证工作，构建 checker 验证机制。

2014自评： REN、MAPQ验证工作，部分SRF验证工作。LSU模块验证，组织学习讲解。
  从零开发：基于ARM XML文档开发的SRF验证工具。CoreMonitor验证方案。FSDB-Trace工具开发

2015：理解、移植、重构基于ESESC建模的L2模型，L2模型Correlation。完成ESL-SOC对接接口代码重构，并完整支持CHI总线请求类型。 开发 CA模型checkin工具，规范checkin流程。

2016：参与 V11x L2 correlation 和 turning 工作。自行开发L2、CHI信号提取工具以提高定位效率。
  移除ESESC代码，整体简化CA代码。从零构建SASOC环境，包括NOC、L3、DDR，支持多核一致性。
  CA模型引入Config机制，改进参数系统，加入Logger和Event系统。输出大量工具和改进建议（20+）。

2017：V2，CA SMT环境支撑，包括 MT checker、MT loader、ARM checker pointer loader、MT Address Manager、DRamSim2集成等工作。SASOC环境支撑，GPL3模型完善。CA模型自身profiling工具开发，仿真性能优化，实现平均速度22到35的优化。性能分析rolling工具开发。

2018： Mobile环境SOC评估模型环境构建，包括Memory trace和inst trace驱动的模型机制开发，强化灵活配置的模型平台。trace相关脚本工具开发。再次整理重构L2模型代码，实现缺失的特性（修正失误15处，添加特性26个，tuning特性5个）。V200T tuning工作：GKB性能分析。开发工具：profile-trace和profile-view。P688-ESL和K3-ESL支撑工作。

2019：L2 Main Code重构（第三次）。实现新的L2特性。新特性开发12个。性能tuning：提出L2-L3联合替换算法，获得GKB 0.34%和SPEC06 1.24%的提升。开发DDRBW模型用于快速多核探索。进入IFU模块，着手MopCache的调试探索。组织团队，新人培养5人。开发新的regr工具套件（包括回归、性能对比）。制定LinxArch的模型方案和qemu方案初稿。

2020：带领团队完成910 L2性能交付（correlation），修复mismatch共18个。和LSU合作完成L2-LSU接口重构。带领完成L2 部分代码整理重构。指导进行IFU/OEX/HWP部分代码重构。与加拿大研究所共同制定并开发了新的LASP平台。模型栈持续演进路线制定，针对真实业务的多模型切换方案规划。确定Gem5在模型栈中的位置，并投入学习和内部推广。

2021：带领团队完成Gem5对910的correlation工作（细节见说明），精度95%，在实践中创建了从零correlation的方法学。LASP平台porting工作。HiDBx相关工作：DBT环境构建，源码分析，效率实测。接手莎莎之后的团队管理工作。之后是人员流失。

2022：RDO项目，LinxISA项目。人员招聘，外包立项，HiDBx立项，外包招聘，外包人员培养。



gem5 910校准结果：精度达到95%超过预定目标（存在部分特性未开启）。仿真速度平均190KIPS。实践并确立了一套correlation方法学，开发若干工具，培养了相关人才。
