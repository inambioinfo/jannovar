/** Lexer for the HGVS mutation nomenclature.
 *
 * Attempts to cover the most important cases for NGS-based analyses.
 *
 * Current limitations:
 *
 * - referencing references for end positions or insertions is currently not
 *   supported, e.g. the following from the HGVS website will not work:
 *
 *   - g.123_678conNG_012232.1:g.9456_10011
 *   - c.88+101_oGJB2:c.355-1045del
 *   - c.123+54_123+55insAB012345.2:g.76_420
 *   - g.123_678conNG_012232.1:g.9456_10011
 *   - c.[NM_000167.5:94A>G;NM_004006.2:76A>C]
 *   - c.123_678conNM_004006.1:c.123_678
 *   - c.88+101_oGJB2:c.355-1045del
 *   - c.123+54_123+55insAB012345.2:g.76_420
 *   - c.[GK:94A>G;DMD:76A>C]
 *
 * @author Manuel Holtgrewe <manuel.holtgrewe@bihealth.de>
 */
lexer grammar HGVSLexer;

/** fire off protein change description*/
PROTEIN_CHANGE_DESCRIPTION
:
	'p.' -> pushMode ( PROTEIN_CHANGE )
;

/** fire off nucleotide change description */
NT_CHANGE_DESCRIPTION
:
	[cmngr] '.' -> pushMode ( NUCLEOTIDE_CHANGE )
;

/** anything that does not match "p." or "[cmngr]." starts a reference description */
REFERENCE
:
	[abdefh-lo-qs-zA-Z0-9] REF_IDENTIFIER
	(
		'.' [1-9] [0-9]* // optional version

	)?
;

/** fragment used for reference identifier */
fragment
REF_IDENTIFIER
:
	[a-zA-Z0-9_]+
;

/** fragment used for protein identifier */
fragment
PROT_IDENTIFIER
:
	[a-zA-Z0-9]+
;

/** opening parenthesis */
PAREN_OPEN
:
	'('
;

/** closing parenthesis */
PAREN_CLOSE
:
	')'
;

/**  used for specifying transcript variant */
TRANS_VAR
:
	'_v'
;

/** used for specifying protein isoform */
PROT_ISO
:
	'_i'
;

/** token used for stopping the reference description */
REF_STOP
:
	':'
;

/** skip line breaks, spaces are kept */
LINE_BREAKS
:
	[ \r\n\t] -> skip
;

/* Lexing of nucleotide changes
 */
mode NUCLEOTIDE_CHANGE;

/** whitespace is ignored */
NT_CHANGE_SPACE
:
	' ' -> skip
;

/** line breaks are ignored and end the nucleotide change parsing*/
NT_CHANGE_LINE_BREAK
:
	[\t\r\n] -> popMode , skip
;

/** a nucleotide character */
NT_CHAR
:
	[ACGTU]
;

/** a number, used for positions etc. */
NT_NUMBER
:
	[1-9] [0-9]*
;

/** literal minus character, for offsets etc. */
NT_MINUS
:
	'-'
;

/** literal plus character, for offsets etc. */
NT_PLUS
:
	'+'
;

/** literal asterisk, for terminal/stop codon */
NT_ASTERISK
:
	'*'
;

/** underscore for ranges */
NT_UNDERSCORE
:
	'_'
;

/** comma, used for multi-change variants */
NT_COMMA
:
	','
;

/** opening parenthesis */
NT_PAREN_OPEN
:
	'('
;

/** closing parenthesis */
NT_PAREN_CLOSE
:
	')'
;

/** double slash for chimeric or mosaic variants */
NT_SLASHES
:
	'//'
	| '/'
;

/** opening square parenthesis, for multi-variant case */
NT_SQUARE_PAREN_OPEN
:
	'['
;

/** closing square parenthesis, for multi-variant case */
NT_SQUARE_PAREN_CLOSE
:
	']'
;

/** semicolon, used in multi-variant case */
NT_SEMICOLON
:
	';'
;

/** token for denoting deletion */
NT_DEL
:
	'del'
;

/** token for denoting duplication */
NT_DUP
:
	'dup'
;

/** token for denoting insertion */
NT_INS
:
	'ins'
;

/** token for denoting inversion */
NT_INV
:
	'inv'
;

NT_EQUAL
:
	'='
;

/** token for denoting splicing */
NT_SPL
:
	'spl'
;

/** token for literal question mark */
NT_QUESTION_MARK
:
	'?'
;

/** token for literal zero */
NT_ZERO
:
	'0'
;

/** literal greater than sign, for denoting single nucleotide change */
NT_GT
:
	'>'
;

/* Lexing of protein changes */
mode PROTEIN_CHANGE;

/** protein character (3-letter, 1-letter or 'X') */
PROTEIN_AA
:
	PROTEIN_AA1
	| PROTEIN_AA3
;

/** number used during protein annotation */
PROTEIN_NUMBER
:
	[1-9] [0-9]*
;

/** space is ignored */
PROTEIN_CHANGE_SPACE
:
	[ ] -> skip
;

/** line breaks are ignored but end protein change mode */
PROTEIN_CHANGE_LINE_BREAK
:
	[\t\r\n] -> popMode , skip
;

/** colon character ends the PROTEIN_CHANGE mode */
PROTEIN_COLON
:
	':' -> popMode
;

/** 3-letter protein codes */
PROTEIN_AA3
:
	'Ala'
	| 'Arg'
	| 'Asn'
	| 'Asp'
	| 'Cys'
	| 'Gln'
	| 'Glu'
	| 'Gly'
	| 'His'
	| 'Ile'
	| 'Leu'
	| 'Lys'
	| 'Met'
	| 'Phe'
	| 'Pro'
	| 'Ser'
	| 'Thr'
	| 'Trp'
	| 'Tyr'
	| 'Val'
;

/** 1-letter protein codes */
PROTEIN_AA1
:
	'A'
	| 'R'
	| 'N'
	| 'D'
	| 'C'
	| 'Q'
	| 'E'
	| 'G'
	| 'H'
	| 'I'
	| 'L'
	| 'K'
	| 'M'
	| 'F'
	| 'P'
	| 'S'
	| 'T'
	| 'W'
	| 'Y'
	| 'V'
;

/** zero, used for denoting no produced protein */
PROTEIN_ZERO
:
	'0'
;

PROTEIN_MINUS
:
	'-'
;

PROTEIN_PLUS
:
	'+'
;

PROTEIN_UNDERSCORE
:
	'_'
;

/** frameshift */
PROTEIN_FS
:
	'fs'
;

/** insertion */
PROTEIN_INS
:
	'ins'
;

/** extension */
PROTEIN_EXT
:
	'ext'
;

/** duplication */
PROTEIN_DUP
:
	'dup'
;

/** deletion */
PROTEIN_DEL
:
	'del'
;

PROTEIN_COMMA
:
	','
;

PROTEIN_EQUAL
:
	'='
;

PROTEIN_QUESTION_MARK
:
	'?'
;

/** start codon with position */
PROTEIN_M1
:
	PROTEIN_MET '1'
;

/** start codon without position */
PROTEIN_MET
:
	'M'
	| 'Met'
;

PROTEIN_PAREN_OPEN
:
	'('
;

PROTEIN_PAREN_CLOSE
:
	')'
;

PROTEIN_SQUARE_PAREN_OPEN
:
	'['
;

PROTEIN_SQUARE_PAREN_CLOSE
:
	']'
;

PROTEIN_SEMICOLON
:
	';'
;

PROTEIN_DASHES
:
	'//'
	| '/'
;

/** terminal codon */
PROTEIN_TERMINAL
:
	'*'
	| 'Ter'
;
