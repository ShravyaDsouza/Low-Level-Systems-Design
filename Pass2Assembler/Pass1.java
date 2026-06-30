import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Pass1 {
    public static void main(String[] args) {

        // Declaration of tables
        Map<String, String[]> optab = new HashMap<>();
        Map<String, Integer> regtab = new HashMap<>();
        LinkedHashMap<String, Object[]> symtab = new LinkedHashMap<>();

        // Symbol Table Pointer
        int symb_ptr = 1;

        // OPTAB
        optab.put("START", new String[]{"AD", "01"});
        optab.put("END",   new String[]{"AD", "02"});
        optab.put("ORIGIN",new String[]{"AD", "03"});
        optab.put("ADD",   new String[]{"IS", "01"});
        optab.put("SUB",   new String[]{"IS", "02"});
        optab.put("MOVER", new String[]{"IS", "04"}); 
        optab.put("MOVEM", new String[]{"IS", "05"}); 
        optab.put("DS",    new String[]{"DL", "01"});
        optab.put("DC",    new String[]{"DL", "02"});

        // REGTAB
        regtab.put("AREG", 1);
        regtab.put("BREG", 2);
        regtab.put("CREG", 3);
        regtab.put("DREG", 4);

        // Input file
        String file_path = "assembly_code.txt";

        // Read program
        List<String> program = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(file_path))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) program.add(line);
            }
        } catch (IOException e) {
            System.err.println("Error reading the file :" + e.getMessage());
            return;
        }

        int lc = 0; // Location Counter

        System.out.println("Intermediate Code:");

        for (String line : program) {
            String[] tokens = line.split("\\s+");
            if (tokens.length == 0) continue;

            if ("START".equals(tokens[0])) {
                String[] op = optab.get("START");
                lc = Integer.parseInt(tokens[1]);
                System.out.println("-\t" + op[0] + ", " + op[1] + "\t" + lc);
                continue;
            }

            if ("END".equals(tokens[0])) {
                String[] op = optab.get("END");
                System.out.println("-\t" + op[0] + ", " + op[1]);
                break;
            }

            if ("ORIGIN".equals(tokens[0])) {
                String[] op = optab.get("ORIGIN");
                lc = Integer.parseInt(tokens[1]);
                System.out.println("-\t" + op[0] + ", " + op[1] + "\t" + lc);
                continue;
            }

            String label = "";
            String opcode;
            String op1 = "";
            String op2 = "";

            if (optab.containsKey(tokens[0])) {
                // No label
                opcode = tokens[0];
                if (tokens.length > 1) op1 = tokens[1];
                if (tokens.length > 2) op2 = tokens[2];
            } else {
                // With label
                label = tokens[0];
                opcode = (tokens.length > 1) ? tokens[1] : "";
                if (tokens.length > 2) op1 = tokens[2];
                if (tokens.length > 3) op2 = tokens[3];
            }

            op1 = op1.replace(",", "");
            op2 = op2.replace(",", "");

            String[] opInfo = optab.get(opcode);
            if (opInfo == null) {
                continue;
            }

            if ("DS".equals(opcode)) {
                int len = Integer.parseInt(op1);

                if (!label.isEmpty()) {
                    Object[] sym = symtab.get(label);
                    if (sym == null) {
                        symtab.put(label, new Object[]{"S" + (symb_ptr++), lc, len});
                    } else {
                        sym[1] = lc;
                        sym[2] = len;
                    }
                }

                System.out.println(lc + "\t" + opInfo[0] + ", " + opInfo[1] + " " + len);
                lc += len;
                continue;
            }

            if ("DC".equals(opcode)) {

                if (!label.isEmpty()) {
                    Object[] sym = symtab.get(label);
                    if (sym == null) {
                        symtab.put(label, new Object[]{"S" + (symb_ptr++), lc, 1});
                    } else {
                        sym[1] = lc;
                        sym[2] = 1;
                    }
                }

                System.out.println(lc + "\t" + opInfo[0] + ", " + opInfo[1] + " " + op1);
                lc += 1;
                continue;
            }

            if ("IS".equals(opInfo[0])) {

                // Label for this instruction
                if (!label.isEmpty()) {
                    Object[] sym = symtab.get(label);
                    if (sym == null) {
                        symtab.put(label, new Object[]{"S" + (symb_ptr++), lc, 1});
                    } else {
                        sym[1] = lc;
                        sym[2] = 1;
                    }
                }

                int regCode = 0;
                if (!op1.isEmpty()) {
                    regCode = regtab.getOrDefault(op1, 0);
                }

                String operandField = "";
                if (!op2.isEmpty()) {
                    // constant
                    if (op2.matches("\\d+")) {
                        operandField = "C," + op2;
                    } else {
                        // symbol
                        Object[] sym = symtab.get(op2);
                        if (sym == null) {
                            sym = new Object[]{"S" + (symb_ptr++), -1, 1};
                            symtab.put(op2, sym);
                        }
                        operandField = (String) sym[0];
                    }
                }

                System.out.println(
                        lc + "\t" + opInfo[0] + ", " + opInfo[1] + " " + regCode + " " + operandField
                );

                lc += 1;
            }
        }

        System.out.println();
        System.out.println("Symbol Table:");
        System.out.printf("%-5s %-10s %-10s %-6s%n", "ID", "Symbol", "Address", "Length");

        for (Map.Entry<String, Object[]> entry : symtab.entrySet()) {
            String symbol = entry.getKey();
            Object[] val = entry.getValue();
            String id = (String) val[0];
            int addr = (int) val[1];
            int len = (int) val[2];
            String addrStr = (addr == -1) ? "??" : String.valueOf(addr);
            System.out.printf("%-5s %-10s %-10s %-6d%n", id, symbol, addrStr, len);
        }

        System.out.println();
        System.out.println("Register Table:");
        for (Map.Entry<String, Integer> e : regtab.entrySet()) {
            System.out.println(e.getKey() + "\t" + e.getValue());
        }
    }
}