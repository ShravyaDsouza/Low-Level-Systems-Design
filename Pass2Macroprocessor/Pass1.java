package Pass2Macroprocessor;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class Pass1 {
    public static void main(String args[]) throws IOException {
		int mdt_ptr = 1;
		int mnt_ptr = 0;
		int ala_ptr = 1;
		int isMacro = 0;

		Map<Integer,String[]> MDT_Table = new HashMap<>();
		Map<Integer,String> ALA = new HashMap<>();
		Map<Integer,String[]> MNT_Table= new HashMap<>();

        BufferedReader br = new BufferedReader(new FileReader("Input_M1_2"));
		BufferedWriter wr = new BufferedWriter(new FileWriter("Ouput_M1"));

		System.out.println("Intermediate Code:");		
		String line ;

        while((line = br.readLine())!=null) {
			line = line.trim();
			if(line.isEmpty()) continue;
			String[] parts = line.split("\\s+");
			if (parts[0].equals("MACRO")) {
				isMacro+=1;
				mnt_ptr +=1;

				String p_line = br.readLine().trim();
				MDT_Table.put(mdt_ptr++, new String[] {p_line});
				String[] p_parts = p_line.split("\\s+");

				MNT_Table.put(mnt_ptr, new String[] { p_parts[0], Integer.toString(mdt_ptr-1) });

				for (int i = 1; i < p_parts.length; i++) {
				    ALA.put(ala_ptr++,p_parts[i]);
				}
				
				String mdtLine;
				
				while (!((mdtLine = br.readLine().trim()).equals("MEND"))) {
					String replaced = mdtLine;
	                for (Map.Entry<Integer, String> e : ALA.entrySet()) {
	                    String formal = e.getValue();
	                    if (formal != null && !formal.isEmpty()) {
	                        replaced = replaced.replace(formal, "#" + e.getKey());
	                    }
	                }

	                MDT_Table.put(mdt_ptr++, new String[]{replaced});
				}

				MDT_Table.put(mdt_ptr++, new String[] { "MEND" });
			}
			else {
				System.out.println(line);
				wr.write(line);
				wr.newLine();
			}
		}

        br.close();
		wr.close();

		System.out.println();
		System.out.println("Total Count of MACRO definitions encountered : "+ isMacro);
        System.out.println("MNT Table:");
        for (Map.Entry<Integer, String[]> entry : MNT_Table.entrySet()) {
            System.out.println(entry.getKey() + " -> " + Arrays.toString(entry.getValue()));
        }
        System.out.println("\nMDT Table:");
        for (Map.Entry<Integer, String[]> entry : MDT_Table.entrySet()) {
            System.out.println(entry.getKey() + " -> " + Arrays.toString(entry.getValue()));
        }
        System.out.println("\nALA:");
        for (Map.Entry<Integer, String> entry : ALA.entrySet()) {
            System.out.println(entry.getKey() + " -> " + entry.getValue());
        }
    }
}
