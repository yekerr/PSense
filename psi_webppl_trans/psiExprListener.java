// Generated from psiExpr.g4 by ANTLR 4.7.1
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link psiExprParser}.
 */
public interface psiExprListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link psiExprParser#prog}.
	 * @param ctx the parse tree
	 */
	void enterProg(psiExprParser.ProgContext ctx);
	/**
	 * Exit a parse tree produced by {@link psiExprParser#prog}.
	 * @param ctx the parse tree
	 */
	void exitProg(psiExprParser.ProgContext ctx);
	/**
	 * Enter a parse tree produced by {@link psiExprParser#func}.
	 * @param ctx the parse tree
	 */
	void enterFunc(psiExprParser.FuncContext ctx);
	/**
	 * Exit a parse tree produced by {@link psiExprParser#func}.
	 * @param ctx the parse tree
	 */
	void exitFunc(psiExprParser.FuncContext ctx);
	/**
	 * Enter a parse tree produced by {@link psiExprParser#type_anno}.
	 * @param ctx the parse tree
	 */
	void enterType_anno(psiExprParser.Type_annoContext ctx);
	/**
	 * Exit a parse tree produced by {@link psiExprParser#type_anno}.
	 * @param ctx the parse tree
	 */
	void exitType_anno(psiExprParser.Type_annoContext ctx);
	/**
	 * Enter a parse tree produced by {@link psiExprParser#comp_op}.
	 * @param ctx the parse tree
	 */
	void enterComp_op(psiExprParser.Comp_opContext ctx);
	/**
	 * Exit a parse tree produced by {@link psiExprParser#comp_op}.
	 * @param ctx the parse tree
	 */
	void exitComp_op(psiExprParser.Comp_opContext ctx);
	/**
	 * Enter a parse tree produced by {@link psiExprParser#ifcond}.
	 * @param ctx the parse tree
	 */
	void enterIfcond(psiExprParser.IfcondContext ctx);
	/**
	 * Exit a parse tree produced by {@link psiExprParser#ifcond}.
	 * @param ctx the parse tree
	 */
	void exitIfcond(psiExprParser.IfcondContext ctx);
	/**
	 * Enter a parse tree produced by {@link psiExprParser#elsecond}.
	 * @param ctx the parse tree
	 */
	void enterElsecond(psiExprParser.ElsecondContext ctx);
	/**
	 * Exit a parse tree produced by {@link psiExprParser#elsecond}.
	 * @param ctx the parse tree
	 */
	void exitElsecond(psiExprParser.ElsecondContext ctx);
	/**
	 * Enter a parse tree produced by {@link psiExprParser#elifcond}.
	 * @param ctx the parse tree
	 */
	void enterElifcond(psiExprParser.ElifcondContext ctx);
	/**
	 * Exit a parse tree produced by {@link psiExprParser#elifcond}.
	 * @param ctx the parse tree
	 */
	void exitElifcond(psiExprParser.ElifcondContext ctx);
	/**
	 * Enter a parse tree produced by {@link psiExprParser#number}.
	 * @param ctx the parse tree
	 */
	void enterNumber(psiExprParser.NumberContext ctx);
	/**
	 * Exit a parse tree produced by {@link psiExprParser#number}.
	 * @param ctx the parse tree
	 */
	void exitNumber(psiExprParser.NumberContext ctx);
	/**
	 * Enter a parse tree produced by the {@code str}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterStr(psiExprParser.StrContext ctx);
	/**
	 * Exit a parse tree produced by the {@code str}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitStr(psiExprParser.StrContext ctx);
	/**
	 * Enter a parse tree produced by the {@code tuple}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterTuple(psiExprParser.TupleContext ctx);
	/**
	 * Exit a parse tree produced by the {@code tuple}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitTuple(psiExprParser.TupleContext ctx);
	/**
	 * Enter a parse tree produced by the {@code arrget}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterArrget(psiExprParser.ArrgetContext ctx);
	/**
	 * Exit a parse tree produced by the {@code arrget}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitArrget(psiExprParser.ArrgetContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ucalc}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterUcalc(psiExprParser.UcalcContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ucalc}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitUcalc(psiExprParser.UcalcContext ctx);
	/**
	 * Enter a parse tree produced by the {@code builtin}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterBuiltin(psiExprParser.BuiltinContext ctx);
	/**
	 * Exit a parse tree produced by the {@code builtin}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitBuiltin(psiExprParser.BuiltinContext ctx);
	/**
	 * Enter a parse tree produced by the {@code length}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterLength(psiExprParser.LengthContext ctx);
	/**
	 * Exit a parse tree produced by the {@code length}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitLength(psiExprParser.LengthContext ctx);
	/**
	 * Enter a parse tree produced by the {@code math}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterMath(psiExprParser.MathContext ctx);
	/**
	 * Exit a parse tree produced by the {@code math}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitMath(psiExprParser.MathContext ctx);
	/**
	 * Enter a parse tree produced by the {@code id}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterId(psiExprParser.IdContext ctx);
	/**
	 * Exit a parse tree produced by the {@code id}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitId(psiExprParser.IdContext ctx);
	/**
	 * Enter a parse tree produced by the {@code calc}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterCalc(psiExprParser.CalcContext ctx);
	/**
	 * Exit a parse tree produced by the {@code calc}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitCalc(psiExprParser.CalcContext ctx);
	/**
	 * Enter a parse tree produced by the {@code lnumber}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterLnumber(psiExprParser.LnumberContext ctx);
	/**
	 * Exit a parse tree produced by the {@code lnumber}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitLnumber(psiExprParser.LnumberContext ctx);
	/**
	 * Enter a parse tree produced by the {@code fcall}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterFcall(psiExprParser.FcallContext ctx);
	/**
	 * Exit a parse tree produced by the {@code fcall}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitFcall(psiExprParser.FcallContext ctx);
	/**
	 * Enter a parse tree produced by the {@code larre}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterLarre(psiExprParser.LarreContext ctx);
	/**
	 * Exit a parse tree produced by the {@code larre}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitLarre(psiExprParser.LarreContext ctx);
	/**
	 * Enter a parse tree produced by the {@code aempty}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 */
	void enterAempty(psiExprParser.AemptyContext ctx);
	/**
	 * Exit a parse tree produced by the {@code aempty}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 */
	void exitAempty(psiExprParser.AemptyContext ctx);
	/**
	 * Enter a parse tree produced by the {@code acat}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 */
	void enterAcat(psiExprParser.AcatContext ctx);
	/**
	 * Exit a parse tree produced by the {@code acat}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 */
	void exitAcat(psiExprParser.AcatContext ctx);
	/**
	 * Enter a parse tree produced by the {@code aarray}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 */
	void enterAarray(psiExprParser.AarrayContext ctx);
	/**
	 * Exit a parse tree produced by the {@code aarray}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 */
	void exitAarray(psiExprParser.AarrayContext ctx);
	/**
	 * Enter a parse tree produced by the {@code abcons}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 */
	void enterAbcons(psiExprParser.AbconsContext ctx);
	/**
	 * Exit a parse tree produced by the {@code abcons}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 */
	void exitAbcons(psiExprParser.AbconsContext ctx);
	/**
	 * Enter a parse tree produced by the {@code aslice}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 */
	void enterAslice(psiExprParser.AsliceContext ctx);
	/**
	 * Exit a parse tree produced by the {@code aslice}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 */
	void exitAslice(psiExprParser.AsliceContext ctx);
	/**
	 * Enter a parse tree produced by the {@code init}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterInit(psiExprParser.InitContext ctx);
	/**
	 * Exit a parse tree produced by the {@code init}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitInit(psiExprParser.InitContext ctx);
	/**
	 * Enter a parse tree produced by the {@code for}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterFor(psiExprParser.ForContext ctx);
	/**
	 * Exit a parse tree produced by the {@code for}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitFor(psiExprParser.ForContext ctx);
	/**
	 * Enter a parse tree produced by the {@code skip}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterSkip(psiExprParser.SkipContext ctx);
	/**
	 * Exit a parse tree produced by the {@code skip}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitSkip(psiExprParser.SkipContext ctx);
	/**
	 * Enter a parse tree produced by the {@code while}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterWhile(psiExprParser.WhileContext ctx);
	/**
	 * Exit a parse tree produced by the {@code while}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitWhile(psiExprParser.WhileContext ctx);
	/**
	 * Enter a parse tree produced by the {@code observe}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterObserve(psiExprParser.ObserveContext ctx);
	/**
	 * Exit a parse tree produced by the {@code observe}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitObserve(psiExprParser.ObserveContext ctx);
	/**
	 * Enter a parse tree produced by the {@code arithassign}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterArithassign(psiExprParser.ArithassignContext ctx);
	/**
	 * Exit a parse tree produced by the {@code arithassign}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitArithassign(psiExprParser.ArithassignContext ctx);
	/**
	 * Enter a parse tree produced by the {@code addsemicolon}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterAddsemicolon(psiExprParser.AddsemicolonContext ctx);
	/**
	 * Exit a parse tree produced by the {@code addsemicolon}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitAddsemicolon(psiExprParser.AddsemicolonContext ctx);
	/**
	 * Enter a parse tree produced by the {@code assert}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterAssert(psiExprParser.AssertContext ctx);
	/**
	 * Exit a parse tree produced by the {@code assert}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitAssert(psiExprParser.AssertContext ctx);
	/**
	 * Enter a parse tree produced by the {@code repeat}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterRepeat(psiExprParser.RepeatContext ctx);
	/**
	 * Exit a parse tree produced by the {@code repeat}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitRepeat(psiExprParser.RepeatContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ainit}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterAinit(psiExprParser.AinitContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ainit}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitAinit(psiExprParser.AinitContext ctx);
	/**
	 * Enter a parse tree produced by the {@code stmtcat}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtcat(psiExprParser.StmtcatContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtcat}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtcat(psiExprParser.StmtcatContext ctx);
	/**
	 * Enter a parse tree produced by the {@code aassign}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterAassign(psiExprParser.AassignContext ctx);
	/**
	 * Exit a parse tree produced by the {@code aassign}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitAassign(psiExprParser.AassignContext ctx);
	/**
	 * Enter a parse tree produced by the {@code if}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterIf(psiExprParser.IfContext ctx);
	/**
	 * Exit a parse tree produced by the {@code if}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitIf(psiExprParser.IfContext ctx);
	/**
	 * Enter a parse tree produced by the {@code cobserve}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterCobserve(psiExprParser.CobserveContext ctx);
	/**
	 * Exit a parse tree produced by the {@code cobserve}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitCobserve(psiExprParser.CobserveContext ctx);
	/**
	 * Enter a parse tree produced by the {@code return}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterReturn(psiExprParser.ReturnContext ctx);
	/**
	 * Exit a parse tree produced by the {@code return}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitReturn(psiExprParser.ReturnContext ctx);
	/**
	 * Enter a parse tree produced by the {@code funcdef}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterFuncdef(psiExprParser.FuncdefContext ctx);
	/**
	 * Exit a parse tree produced by the {@code funcdef}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitFuncdef(psiExprParser.FuncdefContext ctx);
	/**
	 * Enter a parse tree produced by the {@code assign}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterAssign(psiExprParser.AssignContext ctx);
	/**
	 * Exit a parse tree produced by the {@code assign}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitAssign(psiExprParser.AssignContext ctx);
}