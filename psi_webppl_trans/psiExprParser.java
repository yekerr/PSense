// Generated from psiExpr.g4 by ANTLR 4.7.1
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class psiExprParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.7.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, T__25=26, T__26=27, T__27=28, WS=29, TYPE=30, BOP=31, ASOP=32, 
		UOP=33, INT=34, DOUBLE=35, COMMENT=36, STRING=37, LOP=38, COP=39, PRELUDE=40, 
		BUILTIN=41, ID=42;
	public static final int
		RULE_prog = 0, RULE_func = 1, RULE_type_anno = 2, RULE_comp_op = 3, RULE_ifcond = 4, 
		RULE_elsecond = 5, RULE_elifcond = 6, RULE_number = 7, RULE_expr = 8, 
		RULE_arre = 9, RULE_stmt = 10;
	public static final String[] ruleNames = {
		"prog", "func", "type_anno", "comp_op", "ifcond", "elsecond", "elifcond", 
		"number", "expr", "arre", "stmt"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "';'", "'def'", "'('", "','", "')'", "'{'", "'}'", "':'", "'if'", 
		"'else'", "'else if'", "'['", "']'", "'.length'", "'~'", "'array'", "'..'", 
		"':='", "'='", "'observe'", "'cobserve'", "'return'", "'repeat'", "'for'", 
		"'in'", "'while'", "'assert'", "'skip'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, "WS", "TYPE", "BOP", "ASOP", "UOP", "INT", 
		"DOUBLE", "COMMENT", "STRING", "LOP", "COP", "PRELUDE", "BUILTIN", "ID"
	};
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "psiExpr.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public psiExprParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class ProgContext extends ParserRuleContext {
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public List<FuncContext> func() {
			return getRuleContexts(FuncContext.class);
		}
		public FuncContext func(int i) {
			return getRuleContext(FuncContext.class,i);
		}
		public ProgContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_prog; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterProg(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitProg(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitProg(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ProgContext prog() throws RecognitionException {
		ProgContext _localctx = new ProgContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_prog);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(26);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,1,_ctx) ) {
			case 1:
				{
				setState(22);
				stmt(0);
				setState(24);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__0) {
					{
					setState(23);
					match(T__0);
					}
				}

				}
				break;
			}
			setState(29); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(28);
				func();
				}
				}
				setState(31); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==T__1 );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class FuncContext extends ParserRuleContext {
		public List<TerminalNode> ID() { return getTokens(psiExprParser.ID); }
		public TerminalNode ID(int i) {
			return getToken(psiExprParser.ID, i);
		}
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public List<Type_annoContext> type_anno() {
			return getRuleContexts(Type_annoContext.class);
		}
		public Type_annoContext type_anno(int i) {
			return getRuleContext(Type_annoContext.class,i);
		}
		public FuncContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_func; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterFunc(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitFunc(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitFunc(this);
			else return visitor.visitChildren(this);
		}
	}

	public final FuncContext func() throws RecognitionException {
		FuncContext _localctx = new FuncContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_func);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(33);
			match(T__1);
			setState(34);
			match(ID);
			setState(35);
			match(T__2);
			setState(40);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==ID) {
				{
				setState(36);
				match(ID);
				setState(38);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__7) {
					{
					setState(37);
					type_anno();
					}
				}

				}
			}

			setState(49);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__3) {
				{
				{
				setState(42);
				match(T__3);
				setState(43);
				match(ID);
				setState(45);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__7) {
					{
					setState(44);
					type_anno();
					}
				}

				}
				}
				setState(51);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(52);
			match(T__4);
			setState(53);
			match(T__5);
			setState(54);
			stmt(0);
			setState(55);
			match(T__6);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Type_annoContext extends ParserRuleContext {
		public TerminalNode TYPE() { return getToken(psiExprParser.TYPE, 0); }
		public Type_annoContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_type_anno; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterType_anno(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitType_anno(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitType_anno(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Type_annoContext type_anno() throws RecognitionException {
		Type_annoContext _localctx = new Type_annoContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_type_anno);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(57);
			match(T__7);
			setState(58);
			match(TYPE);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Comp_opContext extends ParserRuleContext {
		public TerminalNode BOP() { return getToken(psiExprParser.BOP, 0); }
		public TerminalNode LOP() { return getToken(psiExprParser.LOP, 0); }
		public TerminalNode COP() { return getToken(psiExprParser.COP, 0); }
		public Comp_opContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_comp_op; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterComp_op(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitComp_op(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitComp_op(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Comp_opContext comp_op() throws RecognitionException {
		Comp_opContext _localctx = new Comp_opContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_comp_op);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(60);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << BOP) | (1L << LOP) | (1L << COP))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class IfcondContext extends ParserRuleContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public IfcondContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_ifcond; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterIfcond(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitIfcond(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitIfcond(this);
			else return visitor.visitChildren(this);
		}
	}

	public final IfcondContext ifcond() throws RecognitionException {
		IfcondContext _localctx = new IfcondContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_ifcond);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(62);
			match(T__8);
			setState(63);
			expr(0);
			setState(64);
			match(T__5);
			setState(65);
			stmt(0);
			setState(66);
			match(T__6);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ElsecondContext extends ParserRuleContext {
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public ElsecondContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_elsecond; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterElsecond(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitElsecond(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitElsecond(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ElsecondContext elsecond() throws RecognitionException {
		ElsecondContext _localctx = new ElsecondContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_elsecond);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(68);
			match(T__9);
			setState(69);
			match(T__5);
			setState(70);
			stmt(0);
			setState(71);
			match(T__6);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ElifcondContext extends ParserRuleContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public ElifcondContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_elifcond; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterElifcond(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitElifcond(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitElifcond(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ElifcondContext elifcond() throws RecognitionException {
		ElifcondContext _localctx = new ElifcondContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_elifcond);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(73);
			match(T__10);
			setState(74);
			expr(0);
			setState(75);
			match(T__5);
			setState(76);
			stmt(0);
			setState(77);
			match(T__6);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class NumberContext extends ParserRuleContext {
		public TerminalNode DOUBLE() { return getToken(psiExprParser.DOUBLE, 0); }
		public TerminalNode INT() { return getToken(psiExprParser.INT, 0); }
		public NumberContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_number; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterNumber(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitNumber(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitNumber(this);
			else return visitor.visitChildren(this);
		}
	}

	public final NumberContext number() throws RecognitionException {
		NumberContext _localctx = new NumberContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_number);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(79);
			_la = _input.LA(1);
			if ( !(_la==INT || _la==DOUBLE) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ExprContext extends ParserRuleContext {
		public ExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expr; }
	 
		public ExprContext() { }
		public void copyFrom(ExprContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class StrContext extends ExprContext {
		public TerminalNode STRING() { return getToken(psiExprParser.STRING, 0); }
		public StrContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterStr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitStr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitStr(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TupleContext extends ExprContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public TupleContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterTuple(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitTuple(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitTuple(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ArrgetContext extends ExprContext {
		public TerminalNode ID() { return getToken(psiExprParser.ID, 0); }
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public ArrgetContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterArrget(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitArrget(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitArrget(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class UcalcContext extends ExprContext {
		public TerminalNode UOP() { return getToken(psiExprParser.UOP, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public UcalcContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterUcalc(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitUcalc(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitUcalc(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class BuiltinContext extends ExprContext {
		public TerminalNode BUILTIN() { return getToken(psiExprParser.BUILTIN, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public BuiltinContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterBuiltin(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitBuiltin(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitBuiltin(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class LengthContext extends ExprContext {
		public TerminalNode ID() { return getToken(psiExprParser.ID, 0); }
		public LengthContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterLength(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitLength(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitLength(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class MathContext extends ExprContext {
		public TerminalNode PRELUDE() { return getToken(psiExprParser.PRELUDE, 0); }
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public MathContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterMath(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitMath(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitMath(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class IdContext extends ExprContext {
		public TerminalNode ID() { return getToken(psiExprParser.ID, 0); }
		public IdContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterId(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitId(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitId(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class CalcContext extends ExprContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public Comp_opContext comp_op() {
			return getRuleContext(Comp_opContext.class,0);
		}
		public CalcContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterCalc(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitCalc(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitCalc(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class LnumberContext extends ExprContext {
		public NumberContext number() {
			return getRuleContext(NumberContext.class,0);
		}
		public LnumberContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterLnumber(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitLnumber(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitLnumber(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class FcallContext extends ExprContext {
		public TerminalNode ID() { return getToken(psiExprParser.ID, 0); }
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public FcallContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterFcall(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitFcall(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitFcall(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class LarreContext extends ExprContext {
		public ArreContext arre() {
			return getRuleContext(ArreContext.class,0);
		}
		public LarreContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterLarre(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitLarre(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitLarre(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ExprContext expr() throws RecognitionException {
		return expr(0);
	}

	private ExprContext expr(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		ExprContext _localctx = new ExprContext(_ctx, _parentState);
		ExprContext _prevctx = _localctx;
		int _startState = 16;
		enterRecursionRule(_localctx, 16, RULE_expr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(144);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,12,_ctx) ) {
			case 1:
				{
				_localctx = new MathContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(82);
				match(PRELUDE);
				setState(83);
				match(T__2);
				setState(84);
				expr(0);
				setState(89);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__3) {
					{
					{
					setState(85);
					match(T__3);
					setState(86);
					expr(0);
					}
					}
					setState(91);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(92);
				match(T__4);
				}
				break;
			case 2:
				{
				_localctx = new BuiltinContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(94);
				match(BUILTIN);
				setState(95);
				match(T__2);
				setState(96);
				expr(0);
				setState(97);
				match(T__4);
				}
				break;
			case 3:
				{
				_localctx = new FcallContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(99);
				match(ID);
				setState(100);
				match(T__2);
				setState(109);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__2) | (1L << T__11) | (1L << T__15) | (1L << UOP) | (1L << INT) | (1L << DOUBLE) | (1L << STRING) | (1L << PRELUDE) | (1L << BUILTIN) | (1L << ID))) != 0)) {
					{
					setState(101);
					expr(0);
					setState(106);
					_errHandler.sync(this);
					_la = _input.LA(1);
					while (_la==T__3) {
						{
						{
						setState(102);
						match(T__3);
						setState(103);
						expr(0);
						}
						}
						setState(108);
						_errHandler.sync(this);
						_la = _input.LA(1);
					}
					}
				}

				setState(111);
				match(T__4);
				}
				break;
			case 4:
				{
				_localctx = new UcalcContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(112);
				match(UOP);
				setState(113);
				expr(8);
				}
				break;
			case 5:
				{
				_localctx = new ArrgetContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(114);
				match(ID);
				setState(115);
				match(T__11);
				setState(116);
				expr(0);
				setState(117);
				match(T__12);
				setState(124);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,10,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(118);
						match(T__11);
						setState(119);
						expr(0);
						setState(120);
						match(T__12);
						}
						} 
					}
					setState(126);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,10,_ctx);
				}
				}
				break;
			case 6:
				{
				_localctx = new TupleContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(127);
				match(T__2);
				setState(128);
				expr(0);
				setState(133);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__3) {
					{
					{
					setState(129);
					match(T__3);
					setState(130);
					expr(0);
					}
					}
					setState(135);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(136);
				match(T__4);
				}
				break;
			case 7:
				{
				_localctx = new StrContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(138);
				match(STRING);
				}
				break;
			case 8:
				{
				_localctx = new LnumberContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(139);
				number();
				}
				break;
			case 9:
				{
				_localctx = new LarreContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(140);
				arre(0);
				}
				break;
			case 10:
				{
				_localctx = new LengthContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(141);
				match(ID);
				setState(142);
				match(T__13);
				}
				break;
			case 11:
				{
				_localctx = new IdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(143);
				match(ID);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(152);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,13,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new CalcContext(new ExprContext(_parentctx, _parentState));
					pushNewRecursionContext(_localctx, _startState, RULE_expr);
					setState(146);
					if (!(precpred(_ctx, 12))) throw new FailedPredicateException(this, "precpred(_ctx, 12)");
					setState(147);
					comp_op();
					setState(148);
					expr(13);
					}
					} 
				}
				setState(154);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,13,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class ArreContext extends ParserRuleContext {
		public ArreContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_arre; }
	 
		public ArreContext() { }
		public void copyFrom(ArreContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class AemptyContext extends ArreContext {
		public Type_annoContext type_anno() {
			return getRuleContext(Type_annoContext.class,0);
		}
		public AemptyContext(ArreContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterAempty(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitAempty(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitAempty(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AcatContext extends ArreContext {
		public List<ArreContext> arre() {
			return getRuleContexts(ArreContext.class);
		}
		public ArreContext arre(int i) {
			return getRuleContext(ArreContext.class,i);
		}
		public AcatContext(ArreContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterAcat(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitAcat(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitAcat(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AarrayContext extends ArreContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public AarrayContext(ArreContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterAarray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitAarray(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitAarray(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AbconsContext extends ArreContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public AbconsContext(ArreContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterAbcons(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitAbcons(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitAbcons(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsliceContext extends ArreContext {
		public TerminalNode ID() { return getToken(psiExprParser.ID, 0); }
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public AsliceContext(ArreContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterAslice(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitAslice(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitAslice(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ArreContext arre() throws RecognitionException {
		return arre(0);
	}

	private ArreContext arre(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		ArreContext _localctx = new ArreContext(_ctx, _parentState);
		ArreContext _prevctx = _localctx;
		int _startState = 18;
		enterRecursionRule(_localctx, 18, RULE_arre, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(193);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__2:
				{
				_localctx = new AemptyContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(156);
				match(T__2);
				setState(159); 
				_errHandler.sync(this);
				_la = _input.LA(1);
				do {
					{
					{
					setState(157);
					match(T__11);
					setState(158);
					match(T__12);
					}
					}
					setState(161); 
					_errHandler.sync(this);
					_la = _input.LA(1);
				} while ( _la==T__11 );
				setState(163);
				type_anno();
				setState(164);
				match(T__4);
				}
				break;
			case T__11:
				{
				_localctx = new AbconsContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(166);
				match(T__11);
				setState(167);
				expr(0);
				setState(172);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__3) {
					{
					{
					setState(168);
					match(T__3);
					setState(169);
					expr(0);
					}
					}
					setState(174);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(175);
				match(T__12);
				}
				break;
			case T__15:
				{
				_localctx = new AarrayContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(177);
				match(T__15);
				setState(178);
				match(T__2);
				setState(179);
				expr(0);
				setState(182);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__3) {
					{
					setState(180);
					match(T__3);
					setState(181);
					expr(0);
					}
				}

				setState(184);
				match(T__4);
				}
				break;
			case ID:
				{
				_localctx = new AsliceContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(186);
				match(ID);
				setState(187);
				match(T__11);
				setState(188);
				expr(0);
				setState(189);
				match(T__16);
				setState(190);
				expr(0);
				setState(191);
				match(T__12);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(200);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,18,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new AcatContext(new ArreContext(_parentctx, _parentState));
					pushNewRecursionContext(_localctx, _startState, RULE_arre);
					setState(195);
					if (!(precpred(_ctx, 4))) throw new FailedPredicateException(this, "precpred(_ctx, 4)");
					setState(196);
					match(T__14);
					setState(197);
					arre(5);
					}
					} 
				}
				setState(202);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,18,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class StmtContext extends ParserRuleContext {
		public StmtContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_stmt; }
	 
		public StmtContext() { }
		public void copyFrom(StmtContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class InitContext extends StmtContext {
		public TerminalNode ID() { return getToken(psiExprParser.ID, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public InitContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterInit(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitInit(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitInit(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ForContext extends StmtContext {
		public TerminalNode ID() { return getToken(psiExprParser.ID, 0); }
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public ForContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterFor(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitFor(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitFor(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class SkipContext extends StmtContext {
		public SkipContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterSkip(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitSkip(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitSkip(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class WhileContext extends StmtContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public WhileContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterWhile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitWhile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitWhile(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ObserveContext extends StmtContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ObserveContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterObserve(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitObserve(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitObserve(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ArithassignContext extends StmtContext {
		public TerminalNode ID() { return getToken(psiExprParser.ID, 0); }
		public TerminalNode ASOP() { return getToken(psiExprParser.ASOP, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ArithassignContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterArithassign(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitArithassign(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitArithassign(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AddsemicolonContext extends StmtContext {
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public AddsemicolonContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterAddsemicolon(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitAddsemicolon(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitAddsemicolon(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AssertContext extends StmtContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public AssertContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterAssert(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitAssert(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitAssert(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class RepeatContext extends StmtContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public RepeatContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterRepeat(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitRepeat(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitRepeat(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AinitContext extends StmtContext {
		public TerminalNode ID() { return getToken(psiExprParser.ID, 0); }
		public ArreContext arre() {
			return getRuleContext(ArreContext.class,0);
		}
		public AinitContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterAinit(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitAinit(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitAinit(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtcatContext extends StmtContext {
		public List<StmtContext> stmt() {
			return getRuleContexts(StmtContext.class);
		}
		public StmtContext stmt(int i) {
			return getRuleContext(StmtContext.class,i);
		}
		public StmtcatContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterStmtcat(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitStmtcat(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitStmtcat(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AassignContext extends StmtContext {
		public TerminalNode ID() { return getToken(psiExprParser.ID, 0); }
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public AassignContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterAassign(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitAassign(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitAassign(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class IfContext extends StmtContext {
		public IfcondContext ifcond() {
			return getRuleContext(IfcondContext.class,0);
		}
		public List<ElifcondContext> elifcond() {
			return getRuleContexts(ElifcondContext.class);
		}
		public ElifcondContext elifcond(int i) {
			return getRuleContext(ElifcondContext.class,i);
		}
		public ElsecondContext elsecond() {
			return getRuleContext(ElsecondContext.class,0);
		}
		public IfContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterIf(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitIf(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitIf(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class CobserveContext extends StmtContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public CobserveContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterCobserve(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitCobserve(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitCobserve(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ReturnContext extends StmtContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ReturnContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterReturn(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitReturn(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitReturn(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class FuncdefContext extends StmtContext {
		public FuncContext func() {
			return getRuleContext(FuncContext.class,0);
		}
		public FuncdefContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterFuncdef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitFuncdef(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitFuncdef(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AssignContext extends StmtContext {
		public TerminalNode ID() { return getToken(psiExprParser.ID, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public AssignContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).enterAssign(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof psiExprListener ) ((psiExprListener)listener).exitAssign(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof psiExprVisitor ) return ((psiExprVisitor<? extends T>)visitor).visitAssign(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StmtContext stmt() throws RecognitionException {
		return stmt(0);
	}

	private StmtContext stmt(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		StmtContext _localctx = new StmtContext(_ctx, _parentState);
		StmtContext _prevctx = _localctx;
		int _startState = 20;
		enterRecursionRule(_localctx, 20, RULE_stmt, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(281);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,22,_ctx) ) {
			case 1:
				{
				_localctx = new InitContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(204);
				match(ID);
				setState(205);
				match(T__17);
				setState(206);
				expr(0);
				}
				break;
			case 2:
				{
				_localctx = new ArithassignContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(207);
				match(ID);
				setState(208);
				match(ASOP);
				setState(209);
				expr(0);
				}
				break;
			case 3:
				{
				_localctx = new AinitContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(210);
				match(ID);
				setState(211);
				match(T__17);
				setState(212);
				arre(0);
				}
				break;
			case 4:
				{
				_localctx = new AssignContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(213);
				match(ID);
				setState(214);
				match(T__18);
				setState(215);
				expr(0);
				}
				break;
			case 5:
				{
				_localctx = new AassignContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(216);
				match(ID);
				setState(217);
				match(T__11);
				setState(218);
				expr(0);
				setState(219);
				match(T__12);
				setState(220);
				match(T__18);
				setState(221);
				expr(0);
				}
				break;
			case 6:
				{
				_localctx = new ObserveContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(223);
				match(T__19);
				setState(224);
				match(T__2);
				setState(225);
				expr(0);
				setState(226);
				match(T__4);
				}
				break;
			case 7:
				{
				_localctx = new CobserveContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(228);
				match(T__20);
				setState(229);
				match(T__2);
				setState(230);
				expr(0);
				setState(231);
				match(T__3);
				setState(232);
				expr(0);
				setState(233);
				match(T__4);
				}
				break;
			case 8:
				{
				_localctx = new ReturnContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(235);
				match(T__21);
				setState(236);
				expr(0);
				setState(238);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,19,_ctx) ) {
				case 1:
					{
					setState(237);
					match(T__0);
					}
					break;
				}
				}
				break;
			case 9:
				{
				_localctx = new IfContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(240);
				ifcond();
				setState(244);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,20,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(241);
						elifcond();
						}
						} 
					}
					setState(246);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,20,_ctx);
				}
				setState(248);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,21,_ctx) ) {
				case 1:
					{
					setState(247);
					elsecond();
					}
					break;
				}
				}
				break;
			case 10:
				{
				_localctx = new RepeatContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(250);
				match(T__22);
				setState(251);
				expr(0);
				setState(252);
				match(T__5);
				setState(253);
				stmt(0);
				setState(254);
				match(T__6);
				}
				break;
			case 11:
				{
				_localctx = new ForContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(256);
				match(T__23);
				setState(257);
				match(ID);
				setState(258);
				match(T__24);
				setState(259);
				match(T__11);
				setState(260);
				expr(0);
				setState(261);
				match(T__16);
				setState(262);
				expr(0);
				setState(263);
				match(T__4);
				setState(264);
				match(T__5);
				setState(265);
				stmt(0);
				setState(266);
				match(T__6);
				}
				break;
			case 12:
				{
				_localctx = new WhileContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(268);
				match(T__25);
				setState(269);
				expr(0);
				setState(270);
				match(T__5);
				setState(271);
				stmt(0);
				setState(272);
				match(T__6);
				}
				break;
			case 13:
				{
				_localctx = new AssertContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(274);
				match(T__26);
				setState(275);
				match(T__2);
				setState(276);
				expr(0);
				setState(277);
				match(T__4);
				}
				break;
			case 14:
				{
				_localctx = new FuncdefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(279);
				func();
				}
				break;
			case 15:
				{
				_localctx = new SkipContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(280);
				match(T__27);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(289);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,24,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(287);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,23,_ctx) ) {
					case 1:
						{
						_localctx = new StmtcatContext(new StmtContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_stmt);
						setState(283);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						setState(284);
						stmt(11);
						}
						break;
					case 2:
						{
						_localctx = new AddsemicolonContext(new StmtContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_stmt);
						setState(285);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						setState(286);
						match(T__0);
						}
						break;
					}
					} 
				}
				setState(291);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,24,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 8:
			return expr_sempred((ExprContext)_localctx, predIndex);
		case 9:
			return arre_sempred((ArreContext)_localctx, predIndex);
		case 10:
			return stmt_sempred((StmtContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean expr_sempred(ExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0:
			return precpred(_ctx, 12);
		}
		return true;
	}
	private boolean arre_sempred(ArreContext _localctx, int predIndex) {
		switch (predIndex) {
		case 1:
			return precpred(_ctx, 4);
		}
		return true;
	}
	private boolean stmt_sempred(StmtContext _localctx, int predIndex) {
		switch (predIndex) {
		case 2:
			return precpred(_ctx, 10);
		case 3:
			return precpred(_ctx, 9);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3,\u0127\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\3\2\3\2\5\2\33\n\2\5\2\35\n\2\3\2\6\2 \n\2\r\2\16\2!\3\3\3"+
		"\3\3\3\3\3\3\3\5\3)\n\3\5\3+\n\3\3\3\3\3\3\3\5\3\60\n\3\7\3\62\n\3\f\3"+
		"\16\3\65\13\3\3\3\3\3\3\3\3\3\3\3\3\4\3\4\3\4\3\5\3\5\3\6\3\6\3\6\3\6"+
		"\3\6\3\6\3\7\3\7\3\7\3\7\3\7\3\b\3\b\3\b\3\b\3\b\3\b\3\t\3\t\3\n\3\n\3"+
		"\n\3\n\3\n\3\n\7\nZ\n\n\f\n\16\n]\13\n\3\n\3\n\3\n\3\n\3\n\3\n\3\n\3\n"+
		"\3\n\3\n\3\n\3\n\7\nk\n\n\f\n\16\nn\13\n\5\np\n\n\3\n\3\n\3\n\3\n\3\n"+
		"\3\n\3\n\3\n\3\n\3\n\3\n\7\n}\n\n\f\n\16\n\u0080\13\n\3\n\3\n\3\n\3\n"+
		"\7\n\u0086\n\n\f\n\16\n\u0089\13\n\3\n\3\n\3\n\3\n\3\n\3\n\3\n\3\n\5\n"+
		"\u0093\n\n\3\n\3\n\3\n\3\n\7\n\u0099\n\n\f\n\16\n\u009c\13\n\3\13\3\13"+
		"\3\13\3\13\6\13\u00a2\n\13\r\13\16\13\u00a3\3\13\3\13\3\13\3\13\3\13\3"+
		"\13\3\13\7\13\u00ad\n\13\f\13\16\13\u00b0\13\13\3\13\3\13\3\13\3\13\3"+
		"\13\3\13\3\13\5\13\u00b9\n\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13"+
		"\3\13\5\13\u00c4\n\13\3\13\3\13\3\13\7\13\u00c9\n\13\f\13\16\13\u00cc"+
		"\13\13\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f"+
		"\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3"+
		"\f\3\f\5\f\u00f1\n\f\3\f\3\f\7\f\u00f5\n\f\f\f\16\f\u00f8\13\f\3\f\5\f"+
		"\u00fb\n\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f"+
		"\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\5\f\u011c"+
		"\n\f\3\f\3\f\3\f\3\f\7\f\u0122\n\f\f\f\16\f\u0125\13\f\3\f\2\5\22\24\26"+
		"\r\2\4\6\b\n\f\16\20\22\24\26\2\4\4\2!!()\3\2$%\2\u014c\2\34\3\2\2\2\4"+
		"#\3\2\2\2\6;\3\2\2\2\b>\3\2\2\2\n@\3\2\2\2\fF\3\2\2\2\16K\3\2\2\2\20Q"+
		"\3\2\2\2\22\u0092\3\2\2\2\24\u00c3\3\2\2\2\26\u011b\3\2\2\2\30\32\5\26"+
		"\f\2\31\33\7\3\2\2\32\31\3\2\2\2\32\33\3\2\2\2\33\35\3\2\2\2\34\30\3\2"+
		"\2\2\34\35\3\2\2\2\35\37\3\2\2\2\36 \5\4\3\2\37\36\3\2\2\2 !\3\2\2\2!"+
		"\37\3\2\2\2!\"\3\2\2\2\"\3\3\2\2\2#$\7\4\2\2$%\7,\2\2%*\7\5\2\2&(\7,\2"+
		"\2\')\5\6\4\2(\'\3\2\2\2()\3\2\2\2)+\3\2\2\2*&\3\2\2\2*+\3\2\2\2+\63\3"+
		"\2\2\2,-\7\6\2\2-/\7,\2\2.\60\5\6\4\2/.\3\2\2\2/\60\3\2\2\2\60\62\3\2"+
		"\2\2\61,\3\2\2\2\62\65\3\2\2\2\63\61\3\2\2\2\63\64\3\2\2\2\64\66\3\2\2"+
		"\2\65\63\3\2\2\2\66\67\7\7\2\2\678\7\b\2\289\5\26\f\29:\7\t\2\2:\5\3\2"+
		"\2\2;<\7\n\2\2<=\7 \2\2=\7\3\2\2\2>?\t\2\2\2?\t\3\2\2\2@A\7\13\2\2AB\5"+
		"\22\n\2BC\7\b\2\2CD\5\26\f\2DE\7\t\2\2E\13\3\2\2\2FG\7\f\2\2GH\7\b\2\2"+
		"HI\5\26\f\2IJ\7\t\2\2J\r\3\2\2\2KL\7\r\2\2LM\5\22\n\2MN\7\b\2\2NO\5\26"+
		"\f\2OP\7\t\2\2P\17\3\2\2\2QR\t\3\2\2R\21\3\2\2\2ST\b\n\1\2TU\7*\2\2UV"+
		"\7\5\2\2V[\5\22\n\2WX\7\6\2\2XZ\5\22\n\2YW\3\2\2\2Z]\3\2\2\2[Y\3\2\2\2"+
		"[\\\3\2\2\2\\^\3\2\2\2][\3\2\2\2^_\7\7\2\2_\u0093\3\2\2\2`a\7+\2\2ab\7"+
		"\5\2\2bc\5\22\n\2cd\7\7\2\2d\u0093\3\2\2\2ef\7,\2\2fo\7\5\2\2gl\5\22\n"+
		"\2hi\7\6\2\2ik\5\22\n\2jh\3\2\2\2kn\3\2\2\2lj\3\2\2\2lm\3\2\2\2mp\3\2"+
		"\2\2nl\3\2\2\2og\3\2\2\2op\3\2\2\2pq\3\2\2\2q\u0093\7\7\2\2rs\7#\2\2s"+
		"\u0093\5\22\n\ntu\7,\2\2uv\7\16\2\2vw\5\22\n\2w~\7\17\2\2xy\7\16\2\2y"+
		"z\5\22\n\2z{\7\17\2\2{}\3\2\2\2|x\3\2\2\2}\u0080\3\2\2\2~|\3\2\2\2~\177"+
		"\3\2\2\2\177\u0093\3\2\2\2\u0080~\3\2\2\2\u0081\u0082\7\5\2\2\u0082\u0087"+
		"\5\22\n\2\u0083\u0084\7\6\2\2\u0084\u0086\5\22\n\2\u0085\u0083\3\2\2\2"+
		"\u0086\u0089\3\2\2\2\u0087\u0085\3\2\2\2\u0087\u0088\3\2\2\2\u0088\u008a"+
		"\3\2\2\2\u0089\u0087\3\2\2\2\u008a\u008b\7\7\2\2\u008b\u0093\3\2\2\2\u008c"+
		"\u0093\7\'\2\2\u008d\u0093\5\20\t\2\u008e\u0093\5\24\13\2\u008f\u0090"+
		"\7,\2\2\u0090\u0093\7\20\2\2\u0091\u0093\7,\2\2\u0092S\3\2\2\2\u0092`"+
		"\3\2\2\2\u0092e\3\2\2\2\u0092r\3\2\2\2\u0092t\3\2\2\2\u0092\u0081\3\2"+
		"\2\2\u0092\u008c\3\2\2\2\u0092\u008d\3\2\2\2\u0092\u008e\3\2\2\2\u0092"+
		"\u008f\3\2\2\2\u0092\u0091\3\2\2\2\u0093\u009a\3\2\2\2\u0094\u0095\f\16"+
		"\2\2\u0095\u0096\5\b\5\2\u0096\u0097\5\22\n\17\u0097\u0099\3\2\2\2\u0098"+
		"\u0094\3\2\2\2\u0099\u009c\3\2\2\2\u009a\u0098\3\2\2\2\u009a\u009b\3\2"+
		"\2\2\u009b\23\3\2\2\2\u009c\u009a\3\2\2\2\u009d\u009e\b\13\1\2\u009e\u00a1"+
		"\7\5\2\2\u009f\u00a0\7\16\2\2\u00a0\u00a2\7\17\2\2\u00a1\u009f\3\2\2\2"+
		"\u00a2\u00a3\3\2\2\2\u00a3\u00a1\3\2\2\2\u00a3\u00a4\3\2\2\2\u00a4\u00a5"+
		"\3\2\2\2\u00a5\u00a6\5\6\4\2\u00a6\u00a7\7\7\2\2\u00a7\u00c4\3\2\2\2\u00a8"+
		"\u00a9\7\16\2\2\u00a9\u00ae\5\22\n\2\u00aa\u00ab\7\6\2\2\u00ab\u00ad\5"+
		"\22\n\2\u00ac\u00aa\3\2\2\2\u00ad\u00b0\3\2\2\2\u00ae\u00ac\3\2\2\2\u00ae"+
		"\u00af\3\2\2\2\u00af\u00b1\3\2\2\2\u00b0\u00ae\3\2\2\2\u00b1\u00b2\7\17"+
		"\2\2\u00b2\u00c4\3\2\2\2\u00b3\u00b4\7\22\2\2\u00b4\u00b5\7\5\2\2\u00b5"+
		"\u00b8\5\22\n\2\u00b6\u00b7\7\6\2\2\u00b7\u00b9\5\22\n\2\u00b8\u00b6\3"+
		"\2\2\2\u00b8\u00b9\3\2\2\2\u00b9\u00ba\3\2\2\2\u00ba\u00bb\7\7\2\2\u00bb"+
		"\u00c4\3\2\2\2\u00bc\u00bd\7,\2\2\u00bd\u00be\7\16\2\2\u00be\u00bf\5\22"+
		"\n\2\u00bf\u00c0\7\23\2\2\u00c0\u00c1\5\22\n\2\u00c1\u00c2\7\17\2\2\u00c2"+
		"\u00c4\3\2\2\2\u00c3\u009d\3\2\2\2\u00c3\u00a8\3\2\2\2\u00c3\u00b3\3\2"+
		"\2\2\u00c3\u00bc\3\2\2\2\u00c4\u00ca\3\2\2\2\u00c5\u00c6\f\6\2\2\u00c6"+
		"\u00c7\7\21\2\2\u00c7\u00c9\5\24\13\7\u00c8\u00c5\3\2\2\2\u00c9\u00cc"+
		"\3\2\2\2\u00ca\u00c8\3\2\2\2\u00ca\u00cb\3\2\2\2\u00cb\25\3\2\2\2\u00cc"+
		"\u00ca\3\2\2\2\u00cd\u00ce\b\f\1\2\u00ce\u00cf\7,\2\2\u00cf\u00d0\7\24"+
		"\2\2\u00d0\u011c\5\22\n\2\u00d1\u00d2\7,\2\2\u00d2\u00d3\7\"\2\2\u00d3"+
		"\u011c\5\22\n\2\u00d4\u00d5\7,\2\2\u00d5\u00d6\7\24\2\2\u00d6\u011c\5"+
		"\24\13\2\u00d7\u00d8\7,\2\2\u00d8\u00d9\7\25\2\2\u00d9\u011c\5\22\n\2"+
		"\u00da\u00db\7,\2\2\u00db\u00dc\7\16\2\2\u00dc\u00dd\5\22\n\2\u00dd\u00de"+
		"\7\17\2\2\u00de\u00df\7\25\2\2\u00df\u00e0\5\22\n\2\u00e0\u011c\3\2\2"+
		"\2\u00e1\u00e2\7\26\2\2\u00e2\u00e3\7\5\2\2\u00e3\u00e4\5\22\n\2\u00e4"+
		"\u00e5\7\7\2\2\u00e5\u011c\3\2\2\2\u00e6\u00e7\7\27\2\2\u00e7\u00e8\7"+
		"\5\2\2\u00e8\u00e9\5\22\n\2\u00e9\u00ea\7\6\2\2\u00ea\u00eb\5\22\n\2\u00eb"+
		"\u00ec\7\7\2\2\u00ec\u011c\3\2\2\2\u00ed\u00ee\7\30\2\2\u00ee\u00f0\5"+
		"\22\n\2\u00ef\u00f1\7\3\2\2\u00f0\u00ef\3\2\2\2\u00f0\u00f1\3\2\2\2\u00f1"+
		"\u011c\3\2\2\2\u00f2\u00f6\5\n\6\2\u00f3\u00f5\5\16\b\2\u00f4\u00f3\3"+
		"\2\2\2\u00f5\u00f8\3\2\2\2\u00f6\u00f4\3\2\2\2\u00f6\u00f7\3\2\2\2\u00f7"+
		"\u00fa\3\2\2\2\u00f8\u00f6\3\2\2\2\u00f9\u00fb\5\f\7\2\u00fa\u00f9\3\2"+
		"\2\2\u00fa\u00fb\3\2\2\2\u00fb\u011c\3\2\2\2\u00fc\u00fd\7\31\2\2\u00fd"+
		"\u00fe\5\22\n\2\u00fe\u00ff\7\b\2\2\u00ff\u0100\5\26\f\2\u0100\u0101\7"+
		"\t\2\2\u0101\u011c\3\2\2\2\u0102\u0103\7\32\2\2\u0103\u0104\7,\2\2\u0104"+
		"\u0105\7\33\2\2\u0105\u0106\7\16\2\2\u0106\u0107\5\22\n\2\u0107\u0108"+
		"\7\23\2\2\u0108\u0109\5\22\n\2\u0109\u010a\7\7\2\2\u010a\u010b\7\b\2\2"+
		"\u010b\u010c\5\26\f\2\u010c\u010d\7\t\2\2\u010d\u011c\3\2\2\2\u010e\u010f"+
		"\7\34\2\2\u010f\u0110\5\22\n\2\u0110\u0111\7\b\2\2\u0111\u0112\5\26\f"+
		"\2\u0112\u0113\7\t\2\2\u0113\u011c\3\2\2\2\u0114\u0115\7\35\2\2\u0115"+
		"\u0116\7\5\2\2\u0116\u0117\5\22\n\2\u0117\u0118\7\7\2\2\u0118\u011c\3"+
		"\2\2\2\u0119\u011c\5\4\3\2\u011a\u011c\7\36\2\2\u011b\u00cd\3\2\2\2\u011b"+
		"\u00d1\3\2\2\2\u011b\u00d4\3\2\2\2\u011b\u00d7\3\2\2\2\u011b\u00da\3\2"+
		"\2\2\u011b\u00e1\3\2\2\2\u011b\u00e6\3\2\2\2\u011b\u00ed\3\2\2\2\u011b"+
		"\u00f2\3\2\2\2\u011b\u00fc\3\2\2\2\u011b\u0102\3\2\2\2\u011b\u010e\3\2"+
		"\2\2\u011b\u0114\3\2\2\2\u011b\u0119\3\2\2\2\u011b\u011a\3\2\2\2\u011c"+
		"\u0123\3\2\2\2\u011d\u011e\f\f\2\2\u011e\u0122\5\26\f\r\u011f\u0120\f"+
		"\13\2\2\u0120\u0122\7\3\2\2\u0121\u011d\3\2\2\2\u0121\u011f\3\2\2\2\u0122"+
		"\u0125\3\2\2\2\u0123\u0121\3\2\2\2\u0123\u0124\3\2\2\2\u0124\27\3\2\2"+
		"\2\u0125\u0123\3\2\2\2\33\32\34!(*/\63[lo~\u0087\u0092\u009a\u00a3\u00ae"+
		"\u00b8\u00c3\u00ca\u00f0\u00f6\u00fa\u011b\u0121\u0123";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}