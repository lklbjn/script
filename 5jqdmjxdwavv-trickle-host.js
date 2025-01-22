// 定义执行计数器
let executionCount = 0;
// 定义最大允许执行次数
const maxExecutions = 1000;

// 设置定时器
const intervalId = setInterval(function () {
    // 如果已经达到最大执行次数，清除定时器并停止任务
    if (executionCount >= maxExecutions) {
        clearInterval(intervalId);
        console.log('任务已达到最大执行次数（', maxExecutions, '次），自动停止。');
        return;
    }

    // 增加执行计数
    executionCount++;

    // 获取所有色块元素
    const gridCells = document.querySelectorAll('.grid-wrapper .grid-cell');

    // 用于存储每个色块的背景颜色
    const colors = [];

    // 收集每个色块的背景颜色
    gridCells.forEach(cell => {
        const bgColor = getComputedStyle(cell).backgroundColor;
        colors.push(bgColor);
    });

    // 去重得到唯一颜色列表
    const uniqueColors = [...new Set(colors)];

    let targetColor = null;

    // 找出不同的颜色（假设只有一个格子与其他格子颜色不同）
    if (colors.filter(color => color === uniqueColors[0]).length === 1) {
        targetColor = uniqueColors[0];
    } else if (colors.filter(color => color === uniqueColors[1]).length === 1) {
        targetColor = uniqueColors[1];
    }

    // 如果找到了目标色块，就模拟点击它
    if (targetColor) {
        gridCells.forEach(cell => {
            if (getComputedStyle(cell).backgroundColor === targetColor) {
                cell.click();
                console.log(
                    '第',
                    executionCount,
                    '次点击：已成功点击不同颜色的色块（',
                    targetColor,
                    '）。'
                );
            }
        });
    } else {
        console.warn('第', executionCount, '次：未找到不同颜色的色块。');
    }
}, 10); // 每隔10毫秒运行一次检测和点击
