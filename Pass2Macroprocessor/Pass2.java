package Pass2Macroprocessor;

import java.util.*;
import java.io.*;

public class Pass2 {
    public static void main(String[] args) {
        Map<String, Integer> symtab = new HashMap<>();

        try (BufferedReader br = new BufferedReader(new FileReader("Symbol_Table"))) {
            String line = br.readLine();
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;
                String[] parts = line.split("\\s+");
                if (parts.length >= 3) {
                    String id = parts[0];
                    try {
                        int address = Integer.parseInt(parts[2]);
                        symtab.put(id, address);
                    } catch (NumberFormatException e) {
                        System.err.println("Invalid address in symbol table: " + line);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading Symbol_Table: " + e.getMessage());
            return;
        }

        try (BufferedReader br = new BufferedReader(new FileReader("Intermediate_Code"))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                String[] tokens = line.split("\\s+");
                if (tokens.length < 2) continue;

                String lc = tokens[0];
                String type = tokens[1];

                if (type.equals("AD")) {
                    continue;
                }

                if (type.equals("DL")) {
                    if (tokens.length >= 4) {
                        String constant = tokens[3];
                        try {
                            int val = Integer.parseInt(constant);
                            System.out.println(lc + " 00 0 " + String.format("%03d", val));
                        } catch (NumberFormatException e) {
                            System.err.println("Invalid constant: " + constant);
                        }
                    } else {
                        System.err.println("Incomplete DL line: " + line);
                    }
                    continue;
                }

                if (type.equals("IS")) {
                    if (tokens.length < 5) {
                        System.err.println("Incomplete IS instruction: " + line);
                        continue;
                    }
                    String opcode = tokens[2];
                    String regStr = tokens[3];
                    String operand = tokens[4];

                    int regCode;
                    try {
                        regCode = Integer.parseInt(regStr);
                    } catch (NumberFormatException e) {
                        System.err.println("Invalid register: " + regStr);
                        continue;
                    }

                    int memAddr;
                    if (operand.startsWith("S")) {
                        Integer addr = symtab.get(operand);
                        if (addr == null) {
                            System.err.println("Symbol not found: " + operand);
                            continue;
                        }
                        memAddr = addr;
                    } else if (operand.startsWith("C,")) {
                        String[] p = operand.split(",", 2);
                        if (p.length == 2) {
                            try {
                                memAddr = Integer.parseInt(p[1]);
                            } catch (NumberFormatException e) {
                                System.err.println("Invalid constant format: " + operand);
                                continue;
                            }
                        } else {
                            System.err.println("Invalid constant format: " + operand);
                            continue;
                        }
                    } else {
                        System.err.println("Unrecognized operand: " + operand);
                        continue;
                    }

                    System.out.println(lc + " " + opcode + " " + regCode + " " + String.format("%03d", memAddr));
                    continue;
                }

                System.err.println("Unknown type: " + type + " in line: " + line);
            }
        } catch (IOException e) {
            System.err.println("Error reading Intermediate_Code: " + e.getMessage());
        }
    }
}

