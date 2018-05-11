// Generated from psiExpr.g4 by ANTLR 4.7.1
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link psiExprParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface psiExprVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link psiExprParser#prog}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProg(psiExprParser.ProgContext ctx);
	/**
	 * Visit a parse tree produced by {@link psiExprParser#func}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunc(psiExprParser.FuncContext ctx);
	/**
	 * Visit a parse tree produced by {@link psiExprParser#type_anno}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_anno(psiExprParser.Type_annoContext ctx);
	/**
	 * Visit a parse tree produced by {@link psiExprParser#comp_op}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitComp_op(psiExprParser.Comp_opContext ctx);
	/**
	 * Visit a parse tree produced by {@link psiExprParser#ifcond}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIfcond(psiExprParser.IfcondContext ctx);
	/**
	 * Visit a parse tree produced by {@link psiExprParser#elsecond}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitElsecond(psiExprParser.ElsecondContext ctx);
	/**
	 * Visit a parse tree produced by {@link psiExprParser#elifcond}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitElifcond(psiExprParser.ElifcondContext ctx);
	/**
	 * Visit a parse tree produced by {@link psiExprParser#number}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNumber(psiExprParser.NumberContext ctx);
	/**
	 * Visit a parse tree produced by the {@code str}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStr(psiExprParser.StrContext ctx);
	/**
	 * Visit a parse tree produced by the {@code tuple}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTuple(psiExprParser.TupleContext ctx);
	/**
	 * Visit a parse tree produced by the {@code arrget}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitArrget(psiExprParser.ArrgetContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ucalc}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitUcalc(psiExprParser.UcalcContext ctx);
	/**
	 * Visit a parse tree produced by the {@code builtin}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBuiltin(psiExprParser.BuiltinContext ctx);
	/**
	 * Visit a parse tree produced by the {@code length}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLength(psiExprParser.LengthContext ctx);
	/**
	 * Visit a parse tree produced by the {@code math}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMath(psiExprParser.MathContext ctx);
	/**
	 * Visit a parse tree produced by the {@code id}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitId(psiExprParser.IdContext ctx);
	/**
	 * Visit a parse tree produced by the {@code calc}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCalc(psiExprParser.CalcContext ctx);
	/**
	 * Visit a parse tree produced by the {@code lnumber}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLnumber(psiExprParser.LnumberContext ctx);
	/**
	 * Visit a parse tree produced by the {@code fcall}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFcall(psiExprParser.FcallContext ctx);
	/**
	 * Visit a parse tree produced by the {@code larre}
	 * labeled alternative in {@link psiExprParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLarre(psiExprParser.LarreContext ctx);
	/**
	 * Visit a parse tree produced by the {@code aempty}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAempty(psiExprParser.AemptyContext ctx);
	/**
	 * Visit a parse tree produced by the {@code acat}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAcat(psiExprParser.AcatContext ctx);
	/**
	 * Visit a parse tree produced by the {@code aarray}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAarray(psiExprParser.AarrayContext ctx);
	/**
	 * Visit a parse tree produced by the {@code abcons}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAbcons(psiExprParser.AbconsContext ctx);
	/**
	 * Visit a parse tree produced by the {@code aslice}
	 * labeled alternative in {@link psiExprParser#arre}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAslice(psiExprParser.AsliceContext ctx);
	/**
	 * Visit a parse tree produced by the {@code init}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInit(psiExprParser.InitContext ctx);
	/**
	 * Visit a parse tree produced by the {@code for}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFor(psiExprParser.ForContext ctx);
	/**
	 * Visit a parse tree produced by the {@code skip}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSkip(psiExprParser.SkipContext ctx);
	/**
	 * Visit a parse tree produced by the {@code while}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWhile(psiExprParser.WhileContext ctx);
	/**
	 * Visit a parse tree produced by the {@code observe}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitObserve(psiExprParser.ObserveContext ctx);
	/**
	 * Visit a parse tree produced by the {@code arithassign}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitArithassign(psiExprParser.ArithassignContext ctx);
	/**
	 * Visit a parse tree produced by the {@code addsemicolon}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAddsemicolon(psiExprParser.AddsemicolonContext ctx);
	/**
	 * Visit a parse tree produced by the {@code assert}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssert(psiExprParser.AssertContext ctx);
	/**
	 * Visit a parse tree produced by the {@code repeat}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRepeat(psiExprParser.RepeatContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ainit}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAinit(psiExprParser.AinitContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtcat}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtcat(psiExprParser.StmtcatContext ctx);
	/**
	 * Visit a parse tree produced by the {@code aassign}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAassign(psiExprParser.AassignContext ctx);
	/**
	 * Visit a parse tree produced by the {@code if}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIf(psiExprParser.IfContext ctx);
	/**
	 * Visit a parse tree produced by the {@code cobserve}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCobserve(psiExprParser.CobserveContext ctx);
	/**
	 * Visit a parse tree produced by the {@code return}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitReturn(psiExprParser.ReturnContext ctx);
	/**
	 * Visit a parse tree produced by the {@code funcdef}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFuncdef(psiExprParser.FuncdefContext ctx);
	/**
	 * Visit a parse tree produced by the {@code assign}
	 * labeled alternative in {@link psiExprParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssign(psiExprParser.AssignContext ctx);
}