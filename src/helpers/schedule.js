const schedule = require('node-schedule');
const controlePresencaRepository = require('../core/controlePresenca/controlePresencaRepository');

async function startSchedule()  {
    await fechamentoControlesPresenca();
}

async function fechamentoControlesPresenca() {
    const functionName = arguments.callee.name;
    const cron = '* 5 * * * *';

    console.log(`Schedule "${functionName}" started. Repeating by the CRON rule: ${cron}`);

    schedule.scheduleJob(cron, async () => {
        await controlePresencaRepository.fecharControlesPresenca();
    });

    await controlePresencaRepository.fecharControlesPresenca();
}

startSchedule();