package computerStructure;

public class MultiplyMatrixes {
	public static void main (String[] args) {
		int [][] mat1= new int[2][2];
		int [][] mat2= new int[2][2];
		
		//Fill the mat1 and mat2 print them and print matC
				for(int ii=0; ii<mat1.length; ii++) {
					for(int jj=0; jj<mat1[ii].length; jj++) {
						mat1[ii][jj]= (int)(Math.random()*15);
						System.out.print(mat1[ii][jj]+ " ");
					}
					System.out.println();
				}
				
				System.out.println("\n Matrix2:");
				for(int ii=0; ii<mat2.length; ii++) {
					for(int jj=0; jj<mat2[ii].length; jj++) {
						mat2[ii][jj]= (int)(Math.random()*15);
						System.out.print(mat2[ii][jj]+ " ");
					}
					System.out.println();
				}
		int [][]matC= new int [mat1.length][mat2[0].length];
		//Multiply matrixes:
		if(mat1[0].length== mat2.length) {
			for(int ii=0; ii<mat1.length; ii++) {
				for(int jj=0; jj<mat1[0].length; jj++) {
					for(int kk=0; kk<mat1[0].length; kk++) {
						matC[ii][jj]+= mat1[ii][kk]*mat2[kk][jj];
					}
				}
			}
		}
		
		
	
		
		System.out.println("\nResult of the multiplication of matrixes: ");
		
		for(int ii=0; ii<matC.length; ii++) {
			for(int jj=0; jj<matC[ii].length; jj++) {
				System.out.print(matC[ii][jj] + " ");
			}
			System.out.println();
		}
	}
}
