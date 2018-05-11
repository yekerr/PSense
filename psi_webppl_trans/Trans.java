import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.io.FileInputStream;
import java.io.InputStream;
public class Trans {
    public static void main(String[] args) throws Exception {
        String inputFile = null;
        if ( args.length>0 ) inputFile = args[0];
        InputStream is = System.in;
        if ( inputFile!=null ) is = new FileInputStream(inputFile); 
        ANTLRInputStream input = new ANTLRInputStream(is);
        psiExprLexer lexer = new psiExprLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        psiExprParser parser = new psiExprParser(tokens);
        ParseTree tree = parser.prog(); 
        TransVisitor trans = new TransVisitor(); 
        String ret = trans.visit(tree);
        System.out.print(ret);
    }
}
