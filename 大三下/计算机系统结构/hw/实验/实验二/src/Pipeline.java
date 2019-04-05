import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by NitreExplosion on 2017/5/23.
 */

public class Pipeline {

    public static final int ADD = 0;
    public static final int SUB = ADD + 1;
    public static final int MUL = SUB + 1;
    public static final int DIV = MUL + 1;
    public static final int LOAD = DIV + 1;
    public static final int STORE = LOAD + 1;

    int[] cpuRegisters;
    float[] fpRegisters;

    int[][] fpRegistersStatus;

    ArrayList<String> cmdList;
    ArrayList<Cmd> decodedList;

    TMLBuffer[][] buffers;
    int pc;

    boolean hasParsed;
    boolean isRunning;
    int runTimes;

    float[] memory;

    int[] runningRS;
    int[] restTime;

    ArrayDeque<Integer> loadStoreQueue;

    String parseErrMessage;

    public Pipeline() {
        cpuRegisters = new int[8];
        fpRegisters = new float[32];
        fpRegistersStatus = new int[32][2];
        for (int i = 0; i < 32; i++) {
            fpRegistersStatus[i][0] = -1;
            fpRegisters[i] = 0;
        }

        cmdList = new ArrayList<>();
        pc = 0;

        buffers = new TMLBuffer[4][3]; // add mult load store
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 3; j++)
                buffers[i][j] = new TMLBuffer();

        hasParsed = false;
        isRunning = false;
        runTimes = 0;

        memory = new float[4096];

        runningRS = new int[4];
        restTime = new int[4];
        for (int i = 0; i < 4; i++) {
            runningRS[i] = -1;
            restTime[i] = -1;
        }

        loadStoreQueue = new ArrayDeque<>();
        decodedList = new ArrayList<>();
    }

    public int parser() {
        decodedList = new ArrayList<>();
        parseErrMessage = "未知错误，请参阅设计文档进行语法检查！" +
                "（各个寄存器名的逗号后不应该有空格）";
        int count = 1;
        for (String cmd : cmdList) {
            String[] opList = cmd.split(" |,");

            opList[0] = opList[0].toUpperCase();

            Pattern p = Pattern.compile("^F([0-9]+)$");
            int operator;
            Cmd tempCmd = new Cmd();
            tempCmd.text = cmd;
            switch (opList[0]) {
                case "ADDD": {
                    operator = ADD;
                    break;
                }
                case "SUBD": {
                    operator = SUB;
                    break;
                }
                case "MULD": {
                    operator = MUL;
                    break;
                }
                case "DIVD": {
                    operator = DIV;
                    break;
                }
                case "LD": {
                    operator = LOAD;
                    break;
                }
                case "ST": {
                    operator = STORE;
                    break;
                }
                default:
                    parseErrMessage = String.format("第%d条代码格式有误,操作码不存在", count);
                    return -1;
            }
            tempCmd.code[0] = operator;
            if (operator <= DIV) {
                if (opList.length != 4)
                    return -1;
                for (int i = 1; i < 4; i++) {
                    Matcher m = p.matcher(opList[i]);
                    if (m.find()) {
                        tempCmd.code[i] = Integer.parseInt(m.group(1));
                        if (tempCmd.code[i] >= 30) {
                            parseErrMessage = String.format("第%d条代码格式有误,寄存器编号越界", count);
                            return -1;
                        }
                        if (tempCmd.code[i] % 2 != 0) {
                            parseErrMessage = String.format("第%d条代码格式有误,寄存器编号非偶数", count);
                            return -1;
                        }
                    } else return -1;
                }
            }
            else {
                if (opList.length != 3)
                    return -1;
                Matcher m = p.matcher(opList[1]);
                if (m.find()) {
                    tempCmd.code[1] = Integer.parseInt(m.group(1));
                    if (tempCmd.code[1] >= 30) {
                        parseErrMessage = String.format("第%d条代码格式有误,寄存器编号越界", count);
                        return -1;
                    }
                    if (tempCmd.code[1] % 2 != 0) {
                        parseErrMessage = String.format("第%d条代码格式有误,寄存器编号非偶数", count);
                        return -1;
                    }
                } else return -1;

                Pattern addrP = Pattern.compile("^([0-9]+)\\(R([0-9]+)\\)$");
                Matcher addrM = addrP.matcher(opList[2]);
                if (addrM.find()) {
                    int cpuRNum = Integer.parseInt(addrM.group(2));
                    if (cpuRNum > 8) {
                        parseErrMessage = String.format("第%d条代码格式有误,CPU寄存器编号越界", pc + 1);
                        return -1;
                    }
                    tempCmd.code[2] = Integer.parseInt(addrM.group(1)) + cpuRegisters[cpuRNum];
                } else {
                    addrP = Pattern.compile("^([0-9]+)$");
                    addrM = addrP.matcher(opList[2]);
                    if (addrM.find()) {
                        tempCmd.code[2] = Integer.parseInt(addrM.group(1));
                    } else {
                        parseErrMessage = String.format("第%d条代码语法有误", pc + 1);
                        return -1;
                    }
                }

                if (tempCmd.code[2] < 0 || tempCmd.code[2] >= 4096) {
                    parseErrMessage = String.format("第%d条代码格式有误,内存地址编号越界", pc + 1);
                    return -1;
                }

                if (tempCmd.code[2] % 4 != 0) {
                    parseErrMessage = String.format("第%d条代码执行出错,内存地址未对齐", pc + 1);
                    return -1;
                }
            }
            decodedList.add(tempCmd);
            count++;
        }
        hasParsed = true;
        //System.out.println(loadStoreQueue.size()) ;
        return 0;
    }

    public int run() {
        if (isRunning)
            return -1;
        if (!hasParsed)
            return -1;
        if (cmdList.size() == 0)
            return -1;
        //meminit();
        isRunning = true;
        pc = 0;

//        if (runTimes > 0)
//            clean();
        runTimes++;
        return 0;
    }

    public void meminit(){
        for(int i = 0 ; i < 32 ; i ++){
            fpRegisters[i] = i ;
        }
        for(int i = 0 ; i < 8 ; i ++){
            cpuRegisters[i] = 2*i ;
        }
        for (int i = 0 ; i < 4096 ; i ++){
            memory[i] = i ;
        }
    }

    public void clean() {
        fpRegistersStatus = new int[32][2];
        for (int i = 0; i < 32; i++) {
            fpRegistersStatus[i][0] = -1;
            fpRegistersStatus[i][1] = -1;
            fpRegisters[i] = 0;
        }
        for (int i = 0; i < 8; i++) {
            cpuRegisters[i] = 0;
        }
        for (int i = 0; i < 4096; ++ i) {
            memory[i] = 0;
        }

        pc = 0;

        buffers = new TMLBuffer[4][3];
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 3; j++)
                buffers[i][j] = new TMLBuffer();

        runningRS = new int[4];
        restTime = new int[4];
        for (int i = 0; i < 4; i++) {
            runningRS[i] = -1;
            restTime[i] = -1;
        }

        loadStoreQueue = new ArrayDeque<>();
        for (Cmd aDecodedList : decodedList) aDecodedList.state = 0;
    }

    public int nextStep() {
        if (!isRunning)
            return -1;
        if (cmdList.size() == 0)
            return -1;
        if (writeResult() != 0) return -1;
        whichRSRun();
        if (exe() != 0) return -1;
        if (issue() != 0) return -1;
        return 0;
    }

    public int nextStep(int step) {
        if (!isRunning)
            return -1;
        if (cmdList.size() == 0)
            return -1;
        for (int i = 0; i < step; i++) {
            if (writeResult() != 0) return -1;
            whichRSRun();
            if (exe() != 0) return -1;
            if (issue() != 0) return -1;
        }
        return 0;
    }

    private int issue() {
        if (pc < cmdList.size()) {
            System.out.println(pc);
            Cmd cmd = decodedList.get(pc++);
            int bufferNum;
            switch (cmd.code[0]) {
                case ADD:
                case SUB: {
                    bufferNum = 0;
                    break;
                }
                case MUL:
                case DIV: {
                    bufferNum = 1;
                    break;
                }
                case LOAD: {
                    bufferNum = 2;
                    break;
                }
                case STORE: {
                    bufferNum = 3;
                    break;
                }
                default:
                    return -1;
            }
            if (bufferNum <= 1) {
                boolean flag = false;
                for (int i = 0; i < 3; i++) {
                    if (bufferNum == 1 && i == 2)
                        break;
                    if (!buffers[bufferNum][i].busy) {
                        buffers[bufferNum][i].busy = true;
                        buffers[bufferNum][i].pc = pc;
                        buffers[bufferNum][i].registerNum = cmd.code[1];
                        if (fpRegistersStatus[cmd.code[2]][0] >= 0) {
                            buffers[bufferNum][i].rsIndex[0][0] = fpRegistersStatus[cmd.code[2]][0];
                            buffers[bufferNum][i].rsIndex[0][1] = fpRegistersStatus[cmd.code[2]][1];
                        } else buffers[bufferNum][i].value[0] = fpRegisters[cmd.code[2]];
                        if (fpRegistersStatus[cmd.code[3]][0] >= 0) {
                            buffers[bufferNum][i].rsIndex[1][0] = fpRegistersStatus[cmd.code[3]][0];
                            buffers[bufferNum][i].rsIndex[1][1] = fpRegistersStatus[cmd.code[3]][1];
                        } else buffers[bufferNum][i].value[1] = fpRegisters[cmd.code[3]];

                        fpRegistersStatus[cmd.code[1]][0] = bufferNum;
                        fpRegistersStatus[cmd.code[1]][1] = i;

                        if (bufferNum == 0)
                            buffers[0][i].operator = cmd.code[0] == ADD ? 0 : 1;
                        else
                            buffers[1][i].operator = cmd.code[0] == MUL ? 0 : 1;
                        flag = true;
                        cmd.state = 1;
                        break;
                    }
                }
                if (!flag)
                    pc--;
            } else {
                boolean flag = false;
                for (int i = 0; i < 3; i++)
                    if (!buffers[bufferNum][i].busy) {
                        buffers[bufferNum][i].busy = true;
                        buffers[bufferNum][i].pc = pc;
                        buffers[bufferNum][i].address = cmd.code[2];
                        buffers[bufferNum][i].registerNum = cmd.code[1];

                        if (bufferNum == 3) {
                            if (fpRegistersStatus[cmd.code[1]][0] >= 0) {
                                buffers[bufferNum][i].rsIndex[0][0] = fpRegistersStatus[cmd.code[1]][0];
                                buffers[bufferNum][i].rsIndex[0][1] = fpRegistersStatus[cmd.code[1]][1];
                            }
                            else buffers[bufferNum][i].value[0] = fpRegisters[cmd.code[1]];
                            loadStoreQueue.add(i+3);
                        }

                        if (bufferNum == 2) {
                            fpRegistersStatus[cmd.code[1]][0] = 2;
                            fpRegistersStatus[cmd.code[1]][1] = i;
                            loadStoreQueue.add(i);
                        }
                        flag = true;
                        cmd.state = 1;
                        break;
                    }
                if (!flag)
                    pc--;
            }
        }

        return 0;
    }

    private int whichRSRun() {
        for (int i = 0; i < 2; i++) {
            if (runningRS[i] == -1) {
                for (int j = 0; j < 3; j++) {
                    if (i == 1 && j == 2)
                        break;
                    if (buffers[i][j].busy)
                        if (buffers[i][j].rsIndex[0][0] == -1 && buffers[i][j].rsIndex[1][0] == -1) {
                            runningRS[i] = j;
                            switch (i) {
                                case 0: {
                                    restTime[i] = 2;
                                    break;
                                }
                                case 1: {
                                    if (buffers[i][j].operator == 0)
                                        restTime[i] = 10;
                                    else restTime[i] = 40;
                                    break;
                                }
                            }
                        }
                }
            }
        }
        if (runningRS[2] == -1 && runningRS[3] == -1) {
            if(loadStoreQueue.size() > 0) {
                Integer num = loadStoreQueue.getFirst();
                if (num != null) {
                    //System.out.println((num>2)) ;
                    int bufferNum = num>2? 3:2;
                    int rsIndex = num>2?num-3:num;
                    //System.out.printf("bufferNum is %d; rsIndex is %d\n", bufferNum, rsIndex) ;
                    if (buffers[bufferNum][rsIndex].rsIndex[0][0] == -1) {
                        runningRS[bufferNum] = rsIndex;
                        restTime[bufferNum] = 2;
//                        loadStoreQueue.remove();
                    }
                }
            }
        }
        return 0;
    }

    private int exe() {
        for (int i = 0; i < 4; i++) {
            if (runningRS[i] != -1 && restTime[i] >= 0)
                restTime[i]--;
            if (runningRS[i] != -1 && restTime[i] == 0)
                decodedList.get(buffers[i][runningRS[i]].pc-1).state = 2;
        }
        return 0;
    }

    private int writeResult() {
        for (int i = 0; i < 4; i++) {
            if (runningRS[i] != -1 && restTime[i] == 0) {
                float result = 0;
                switch (i) {
                    case 0: {
                        result = buffers[i][runningRS[i]].value[0];
                        if (buffers[i][runningRS[i]].operator == 0)
                            result += buffers[i][runningRS[i]].value[1];
                        else result -= buffers[i][runningRS[i]].value[1];
                        fpRegisters[decodedList.get(buffers[i][runningRS[i]].pc - 1).code[1]] = result;
                        break;
                    }
                    case 1: {
                        result = buffers[i][runningRS[i]].value[0];
                        if (buffers[i][runningRS[i]].operator == 0)
                            result *= buffers[i][runningRS[i]].value[1];
                        else result /= buffers[i][runningRS[i]].value[1];
                        fpRegisters[decodedList.get(buffers[i][runningRS[i]].pc - 1).code[1]] = result;
                        break;
                    }
                    case 2: {
                        result = memory[buffers[i][runningRS[i]].address];
                        fpRegisters[decodedList.get(buffers[i][runningRS[i]].pc - 1).code[1]] = result;
                        loadStoreQueue.remove();
                        break;
                    }
                    case 3: {
                        memory[buffers[i][runningRS[i]].address] = buffers[i][runningRS[i]].value[0];
                        break;
                    }
                }
                if (i == 3) {
                    for (int j = 0; j < 31; j+=2)
                        if (fpRegistersStatus[j][0] == i && fpRegistersStatus[j][1] == runningRS[i]) {
                            fpRegistersStatus[j][0] = fpRegistersStatus[j][1] = -1;
                            break;
                        }
                    loadStoreQueue.remove();
                    decodedList.get(buffers[i][runningRS[i]].pc-1).state = 3;
                    buffers[i][runningRS[i]] = new TMLBuffer();
                    runningRS[i] = -1;
                    break;
                }
                for (int j = 0; j < 4; j++)
                    for (int k = 0; k < 3; k++)
                        if (buffers[j][k].busy) {
                            if (buffers[j][k].rsIndex[0][0] == i && buffers[j][k].rsIndex[0][1] == runningRS[i]) {
                                buffers[j][k].rsIndex[0][0] = buffers[j][k].rsIndex[0][1] = -1;
                                buffers[j][k].value[0] = result;
                            }
                            if (buffers[j][k].rsIndex[1][0] == i && buffers[j][k].rsIndex[1][1] == runningRS[i]) {
                                buffers[j][k].rsIndex[1][0] = buffers[j][k].rsIndex[1][1] = -1;
                                buffers[j][k].value[1] = result;
                            }
                        }
                for (int j = 0; j < 31; j+=2)
                    if (fpRegistersStatus[j][0] == i && fpRegistersStatus[j][1] == runningRS[i]) {
                        fpRegistersStatus[j][0] = fpRegistersStatus[j][1] = -1;
                        break;
                    }
                decodedList.get(buffers[i][runningRS[i]].pc-1).state = 3;
                buffers[i][runningRS[i]] = new TMLBuffer();
                runningRS[i] = -1;
                break;
            }
        }
        return 0;
    }

    public int addCmd(String cmd) {
        if (isRunning)
            return -1;
        hasParsed = false;
        cmdList.add(cmd);
        return 0;
//        System.out.print(cmdList);
    }
}
