# Middleware发出信号说明
- isphoto

    1： Middleware已触发3d拍照
- graspused： 抓取点标志
- result： 3D拍照结果标志

    -1： 无抓取点/错误

    1： 成功

    3： 空框

    4： 移框

- workflow： 工作流切换完成信号

    1： workflow切换完成
- XREAL/YREAL/AREAL： 2D拍照矫正数据X/Y/A偏移
- result2d： 2D拍照结果标志（具体值意义参考2D软件说明）

# 机器人任务
机器人可通过发送字符串到Middleware触发下列任务：
- 3D拍照任务（在配置文件中设置，通常为“capture“）

    任务说明：触发3D相机拍照，生成机器人（可达/无碰撞）的抓取轨迹

    返回：返回3D拍照结果、抓取轨迹

- 2D拍照任务（在配置文件中设置，通常为“capture2d”）

    任务说明：触发3D相机拍照，生成抓取的工件的状态和偏移信息

    返回：返回2D拍照结果、偏移量
- workflowxxx

    任务说明：触发Roboeye工作流切换

    返回： 工作流切换完成信号
- tmiexxx
    任务说明：记录与上一次tmiexxx任务之间的时间差值， 并写入到middleware_time_cost.log文件中

    返回： 无

- ClearFailedGrasps

    任务说明：清除失败的抓取点数据

    返回： 无
- ClearTrajectory

    任务说明：清除现存抓取轨迹

    返回： 无
- Error <error_id>
    任务说明：触发机器人异常处理，如果error_id在配置文件中没有设置，则不做处理

    返回： 无
- ResetApp2D
    任务说明：清除2D矫正数据

    返回： 无

# 版本更新记录
## version 1.0.4
1. 增加配置 switch_workflow_msg_2d，在切换workflow时发送flag对应的字符串给app2d

    例如： 配置内容为：
    ```
        switch_workflow_msg_2d:
            Right: "VCGP, 0\r\n"
            Left: "VCGP, 1\r\n"
    ```
    则在切换到workflow “Left”成功后，发送"VCGP, 1\r\n"字符串给app2

## version 1.0.5
1. 增加数据收集相关配置:
    ```
        webcam_enable： 使能网络摄像头
        issue_dataset_name： issue 名称

    ```

## version 1.0.6
1. 增加机器人轨迹数据收集

## version 1.0.7
1. 增加放置点配置：设置参数时，放置点flag应当与2d模板flag一致， 放置点名称应当与机器人程序中实际移动的放置点变量名一致

## version 1.0.8
1. 增加机器人可触发的任务：ClearFailedGrasps（清除失败的抓取点数据），ClearTrajectory（清除现存抓取轨迹）
2. 切换workflow时，更新graspused信号到机器人
3. 增加app2d切换模板指令回复解析

## verion 1.0.9
1. 启用middleware gui
    update.sh： 用于生成middleware.desktop。首次使用，或者移动middleware后需要执行该脚本刷新middleware.desktop文件
    middleware.desktop： 双击启动middleware

## verion 1.0.10
1. 支持多次2D矫正
    ```
        新增参数:
        #2d校正阈值， 当x,y,a任一矫正值大于设定值时，都应当再次进行2d矫正(发送给机器人的2D信号result2d=100)
        #当阈值为0时，当所有参数都为0时， 只做单次2d矫正
        app2d_adjust_threshold_x: 0
        app2d_adjust_threshold_y: 0
        app2d_adjust_threshold_a: 0
    ```
## version 1.0.11
1. 实现机器人异常处理
    1. 机器人可通过发送字符串“Error <error_id>”, 到middleware主动触发错误处理流程，其中error_id为错误码，
    与机器人异常处理参数中的error_id为同一概念，如果error_id在参数中没有设置，则不做处理
    2. 增加异常处理参数
    ```
    #机器人异常处理参数
    robot_error_handler:
    reset:
        #当机器人发送的error_id在当前列表中， 则触发reset任务
        #reset操作：
        #1. 清除报警信息;
        #2. 重新加载机器人程序为reset_project工程中的reset_program程序
        #3. 开始执行第2步加载的程序
        error_id: []
        reset_project: ""
        reset_program: ""
    collect_failure_case:
        #当机器人发送的error_id在当前列表中， 则触发数据数据收集任务
        error_id: []
    ```
    3. 如果配置文件中：robot_monitor_enable=True， middleware会自动检测机器人状态， 并根据2中的设置对检测到的机器人状态作出处理
2. 修复middleware gui reload异常
3. 新增home到above的路径检测
    ```
    #各类抓取点对应的home点关节坐标,用于home点到上方点运动轨迹的检测
    home_as_jpose:
    final_grasps:
        [ -97.45, -1317, 22.53, 0.04, 79.96, -1.3]
    final_grasps_1:
        [-0.02, -13.18, 22.53, 0.04, 79.97, -1.31]
    ```
4. 原robot_monitor_enable参数拆分为两个参数来实现：
    ```
    robot_monitor_enable ——> robot_monitor_enable/robot_monitor_vis_enable
    #实时获取机器人状态
    robot_monitor_enable: True
    #启用机器人实时动作监控图形窗口
    robot_monitor_vis_enable: False

    ```
## version 1.0.12
1. 支持多个2d/3d触发指令
    通过配置参数trigger/trigger2d来设定拍照任务， 参数示例如下：
    ```
    trigger:
     - 'capture'
     - 'capture1'
    trigger2d:
     - 'capture2d'
     - 'capture2d1'
     - 'capture2d2'
    ```
2. 支持G004工作站抓取任务，该任务的差异如下(差异细节参考[文档](https://e34j74nspv.feishu.cn/docx/doxcnR3ZvcICVNZDWSvxt1zCYec))：
    - Roboeye一次发送多组抓取点/物体
    - middleware根据接收到的抓取点生成多组轨迹/信号
    - middleware不会主动清除失败抓取点

    启用G004工作站处理逻辑的方法: 通过在config.yml中新增参数task,并将值设置为G004
    ```
    #启用G004工作站处理逻辑
    task: "G004"
    ```
3. 2d矫正数据清除：通过机器人发送“ResetApp2D”触发
4. 实时监控issue dir，确保文件夹数量不超过规定数量（默认20个）， 可通过参数调整上限值
    ```
    #确保issue dir中文件夹数量不超过规定数量（默认20个）
    max_issue_num: 20

    ```
5. 增加2D标定支持
    1. 加入2D标定支持使能配置, 当该参数设置为True时, middleware会定期给Roboeye发送机器人世界坐标,该参数默认为False
    ```
    #2D标定支持
    enable_calibration_2d_tool: True
    ```
    2. 支持app控制机器人坐标
