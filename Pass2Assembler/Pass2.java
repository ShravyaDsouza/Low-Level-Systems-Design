import java.io.*;
import java.util.*;

public class Pass2 {
    public static void main(String[] args) {

        Map<String, Integer> symtab = new HashMap<>();

        try (BufferedReader br = new BufferedReader(new FileReader("symbol_table.txt"))) {
            String line = br.readLine(); // skip header
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                String[] parts = line.split("\\s+");  
                if (parts.length >= 3) {
                    int addr = Integer.parseInt(parts[2]);
                    symtab.put(parts[0], addr);    
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading Symbol_Table: " + e.getMessage());
            return;
        }

        try (BufferedReader br = new BufferedReader(new FileReader("intermediate_code.txt"))) {
            String line;

            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                String[] t = line.split("\\s+");
                if (t.length < 2) continue;

                String lc   = t[0];              
                String type = t[1].replace(",", "");  

                if ("AD".equals(type)) {
                    continue;
                }

                if ("DL".equals(type)) {
                    int value = Integer.parseInt(t[3]);
                    System.out.println(lc + " 00 0 " + String.format("%03d", value));
                    continue;
                }

                if ("IS".equals(type)) {
                    String opcode = t[2];          
                    int reg      = Integer.parseInt(t[3]);
                    String op    = t[4];         

                    int memAddr;
                    if (op.startsWith("C,")) {    
                        memAddr = Integer.parseInt(op.substring(2));
                    } else {                      
                        memAddr = symtab.get(op);
                    }

                    System.out.println(lc + " " + opcode + " " + reg + " " +
                            String.format("%03d", memAddr));
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading Intermediate_Code: " + e.getMessage());
        }
    }
}
