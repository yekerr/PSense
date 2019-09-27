import java.util.*;
public class TransVisitor extends psiExprBaseVisitor<String> {
    @Override
    public String visitProg(psiExprParser.ProgContext ctx) {
        String ret = "";
        if(ctx.stmt() != null){
            ret += visit(ctx.stmt());
        }
        ret += '\n';
        for(int i = 0; i < ctx.func().size(); i++){
            ret += visit(ctx.func(i));
        }
        ret += "Infer({method: 'MCMC', samples: 1000},main)\n";
        return ret;
    }

    @Override
    public String visitFunc(psiExprParser.FuncContext ctx) {
        String ret = "var " + ctx.ID(0).getText() +" = function(";
        for(int i = 1; i < ctx.ID().size(); i++){
            if(i == 1){
                ret += ctx.ID(i).getText();
            }
            else{
                ret += ",";
                ret += ctx.ID(i).getText();
            }
        }
        ret += "){\n" + visit(ctx.stmt()) + "}\n";
        for(int i = 1;  i < ctx.ID().size(); i++){
            ret = ret.replace("globalStore." + ctx.ID(i).getText(), ctx.ID(i).getText());
        }
        return ret; 
    }


    @Override
    public String visitComp_op(psiExprParser.Comp_opContext ctx) {
        String Bop = ctx.getText();
        String ret = " " + Bop + " ";
        return ret;
    }

    @Override
    public String visitNumber(psiExprParser.NumberContext ctx) {
        return ctx.getText();
    }

    @Override
    public String visitFcall(psiExprParser.FcallContext ctx) {
        String ret = ctx.ID().getText() + "(";
        for(int i = 0; i < ctx.expr().size(); i++){
            if(i == 0) {
                ret += visit(ctx.expr(i));
            }
            else {
                ret += ",";
                ret += visit(ctx.expr(i));
            } 
        }
        ret += ")";
        return ret;
    }

    @Override
    public String visitIfcond(psiExprParser.IfcondContext ctx) {
        String ret = "if (" + visit(ctx.expr()) + ") {" + visit(ctx.stmt()) + "}\n";
        return ret;
    }

    @Override
    public String visitIf(psiExprParser.IfContext ctx) {
        String ret = visit(ctx.ifcond());
        for(int i = 0; i < ctx.elifcond().size(); i++){
            ret += visit(ctx.elifcond(i));
        }
        if(ctx.elsecond() != null){
            ret += visit(ctx.elsecond());
        }
        return ret;
    }

    @Override
    public String visitElsecond(psiExprParser.ElsecondContext ctx) {
        String ret = "else {" + visit(ctx.stmt());
        ret += "}\n";
        return ret;
    }

    @Override
    public String visitElifcond(psiExprParser.ElifcondContext ctx) {
        String ret = "else if (";
        ret += visit(ctx.expr());
        ret += ") {";
        ret += visit(ctx.stmt());
        ret += "}\n";
        return ret;
    }

    @Override
    public String visitStr(psiExprParser.StrContext ctx) {
        String ret = ctx.getText();
        return ret;
    }

    @Override
    public String visitTuple(psiExprParser.TupleContext ctx) {
        //TODO: WebPPL doesn't support tuple
        //Only return the first expression
        String ret = "(";
        ret += visit(ctx.expr(0));
        ret += ")";
        return ret;
    }

    @Override
    public String visitArrget(psiExprParser.ArrgetContext ctx) {
        String ret = "globalStore." + ctx.ID().getText() + "[";
        for(int i = 0; i < ctx.expr().size(); i++){
            if(i == 0) {
                ret += visit(ctx.expr(i));
            }
            else {
                ret += "][";
                ret += visit(ctx.expr(i));
            } 
        }
        ret += "]";
        return ret;
    }

    @Override
    public String visitUcalc(psiExprParser.UcalcContext ctx) {
        String ret = ctx.UOP().getText();
        ret += visit(ctx.expr());
        return ret;
    }

    @Override
    public String visitBuiltin(psiExprParser.BuiltinContext ctx) {
        //TODO
        String funID = ctx.BUILTIN().getText();
        String ret = "";
        if (funID.equals("readCSV")) {
            ret += "csv.read(" + visit(ctx.expr()) + ")";
        }
        else {
            ret += visit(ctx.expr());  
        }
        return ret;
    }

    @Override
    public String visitMath(psiExprParser.MathContext ctx) {
        String prelude = ctx.PRELUDE().getText();
        if(prelude.equals("gauss")){
            prelude = "gaussian";
        }
        if(prelude.equals("uniformInt")){
            prelude = "randomInteger";
        }
        String ret = prelude + "(";
        if(prelude.equals("categorical")){
            String psExp = visit(ctx.expr(0));
            ret += "{vs: mapN(function(x) {return x;}, ";
            ret += psExp;
            ret += ".length) , ps: ";
            ret += psExp;
            ret += "}";
            ret += ")";
        }
        else if (prelude.equals("randomInteger")){
            String intL = visit(ctx.expr(0));
            String intU = visit(ctx.expr(1));
            ret += "(" + intU + ")-(" + intL + ")+1";
            ret += ")";
            ret += "+" + intL;
        }
        else if (prelude.equals("dirichlet")){
            ret += "Vector(";
            ret += visit(ctx.expr(0));
            ret += "))";
        }
        else {
            for(int i = 0; i < ctx.expr().size(); i++){
                if(i == 0) {
                    ret += visit(ctx.expr(i));
                }
                else {
                    ret += ",";
                    ret += visit(ctx.expr(i));
                } 
            }
            ret += ")";
        }
        return ret;
    }


    @Override
    public String visitId(psiExprParser.IdContext ctx) {
        String ret = "globalStore." + ctx.getText();
        return ret;
    }

    @Override
    public String visitCalc(psiExprParser.CalcContext ctx) {
        String ret = visit(ctx.expr(0));
        ret += visit(ctx.comp_op());
        ret += visit(ctx.expr(1));
        return ret;
    }
    
    @Override
    public String visitLnumber(psiExprParser.LnumberContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public String visitAempty(psiExprParser.AemptyContext ctx) {
        String ret = "[]";
        return ret;
    }

    @Override
    public String visitAcat(psiExprParser.AcatContext ctx) {
        String ret = visit(ctx.arre(0));
        ret += ".concat(";
        ret += visit(ctx.arre(1));
        ret += ")";
        return ret;
    }

    @Override
    public String visitAbcons(psiExprParser.AbconsContext ctx) {
        String ret = "[";
        for(int i = 0; i < ctx.expr().size(); i++){
            if(i == 0) {
                ret += visit(ctx.expr(i));
            }
            else {
                ret += ",";
                ret += visit(ctx.expr(i));
            } 
        }
        ret += "]";
        return ret;
    }

    @Override
    public String visitAarray(psiExprParser.AarrayContext ctx) {
        String ret = "repeat(";
        ret += visit(ctx.expr(0));
        ret += ", function() {return ";
        if(ctx.expr(1) != null) {
            ret += visit(ctx.expr(1));
        }
        else {
            ret += "0";
        }
        ret += "})";
        return ret;
    }

    @Override
    public String visitAslice(psiExprParser.AsliceContext ctx) {
        String ret = "globalStore." + ctx.ID().getText() + ".slice("; 
        ret += visit(ctx.expr(0));
        ret += ",";
        ret += visit(ctx.expr(1));
        ret += ")";
        return ret;
    }

    @Override
    public String visitInit(psiExprParser.InitContext ctx) {
        String ret = "globalStore." + ctx.ID().getText() + " = ";
        ret += visit(ctx.expr());
        return ret;
    }

    @Override
    public String visitFor(psiExprParser.ForContext ctx) {
        String iterID = "globalStore." + ctx.ID().getText();
        String retpre = iterID + " = ";
        retpre += visit(ctx.expr(0));
        retpre += ";\n";
        String ret = "var forLoop = function(";
        ret += ctx.ID().getText();
        ret += "){\nif (" + ctx.ID().getText() + " == ";
        ret += visit(ctx.expr(1));
        ret += ") return;\n";
        ret += visit(ctx.stmt());
        ret += "\nforLoop(" + ctx.ID().getText() + " + 1);\nreturn;\n}\n";
        ret = ret.replace(iterID, ctx.ID().getText());
        ret = retpre + ret + "forLoop(" + iterID + ");\n";
        return ret;
    }

    @Override
    public String visitLength(psiExprParser.LengthContext ctx) {
        String ret = ctx.ID().getText() + ".length";
        return ret;
    }

    @Override
    public String visitAddsemicolon(psiExprParser.AddsemicolonContext ctx) {
        return visit(ctx.stmt());
    }

	@Override
    public String visitWhile(psiExprParser.WhileContext ctx) {
        //TODO
        String ret = "var whileloop = function(){\nif (!(";
        ret += visit(ctx.expr());
        ret += ")) return;\n";
        ret += visit(ctx.stmt());
        ret += "\nwhileloop();\nreturn;\n}\n";
        ret += "whileloop(" + visit(ctx.expr()) + ");\n";
        return ret;
    }

    @Override
    public String visitArithassign(psiExprParser.ArithassignContext ctx) {
        String ret = "globalStore." + ctx.ID().getText() + " = globalStore." + ctx.ID().getText();
        if (ctx.ASOP().getText().equals("~=")){
            ret += ".concat(" + visit(ctx.expr()) + ")";
        }
        else{
            ret += " " + ctx.ASOP().getText().replace("=","") + " ";
            ret += visit(ctx.expr());
        }
        return ret;
    }

	@Override
    public String visitRepeat(psiExprParser.RepeatContext ctx) {
        //TODO
        String ret = "var repeatloop = function(iter){\nif (iter == ";
        ret += visit(ctx.expr());
        ret += ") return;\n";
        ret += visit(ctx.stmt());
        ret += "\nrepeatloop(iter + 1);\nreturn;\n}\n";
        ret += "repeatloop(0);\n";
        return ret;
    }

    @Override
    public String visitObserve(psiExprParser.ObserveContext ctx) {
        String ret = "condition(";
        ret += visit(ctx.expr());
        ret += ")";
        return ret;
    }

    @Override
    public String visitAssign(psiExprParser.AssignContext ctx) {
        String ret = "globalStore." + ctx.ID().getText() + " = ";
        ret += visit(ctx.expr());
        return ret;
    }

    @Override
    public String visitAinit(psiExprParser.AinitContext ctx) {
        String ret = "globalStore." + ctx.ID().getText() + " = ";
        ret += visit(ctx.arre());
        return ret;
    }

    @Override
    public String visitStmtcat(psiExprParser.StmtcatContext ctx) {
        String ret = visit(ctx.stmt(0));
        ret += "\n";
        ret += visit(ctx.stmt(1));
        return ret;
    }

	@Override 
    public String visitAassign(psiExprParser.AassignContext ctx) {
        //TODO
        String ret = "";
        String globalID = "globalStore." + ctx.ID();
        String copyID = ctx.ID() + "Copy";
        ret += "var " + copyID + " = " + globalID + "\n";
        ret += "var pair = function(ind, x) { if(ind == " + visit(ctx.expr(0)) + "){return ("
            + visit(ctx.expr(ctx.expr().size() - 1)).replace(globalID, copyID) +
            ")} else{return x} };\n";
        ret += globalID + " = mapIndexed(pair, " + copyID + ");\n";
        return ret;
    }

    @Override
    public String visitCobserve(psiExprParser.CobserveContext ctx){
        String ret = "factor((";
        ret += visit(ctx.expr(0));
        ret += "==";
        ret += visit(ctx.expr(1));
        ret += ")?0:-Infinity)";
        return ret;
    }

    @Override
    public String visitReturn(psiExprParser.ReturnContext ctx) {
        String ret = "return ";
        ret += visit(ctx.expr());
        ret += ";\n";
        return ret;
    }



}
