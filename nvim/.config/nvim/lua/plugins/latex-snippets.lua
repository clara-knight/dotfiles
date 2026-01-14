-- LaTeX snippets for LuaSnip
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Configure LuaSnip to enable autosnippets
ls.config.set_config({
    -- This option enables the autoexpansion of snippets.
    enable_autosnippets = true,
})

-- Helper function to check if we're in math mode
-- Returns false if vimtex is not available to prevent errors
local in_mathzone = function()
    if vim.fn.exists('*vimtex#syntax#in_mathzone') == 0 then
        return false
    end
    return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

-- ============================================================================
-- AUTO-EXPAND SNIPPETS (Safe to expand automatically)
-- ============================================================================

-- Text mode auto-expand snippets
local text_autosnippets = {
    -- Text formatting
    s({ trig = 'emph', snippetType = 'autosnippet' }, { t('\\emph{'), i(1, 'text'), t('}') }),
    s({ trig = 'textbf', snippetType = 'autosnippet' }, { t('\\textbf{'), i(1, 'text'), t('}') }),
    s({ trig = 'textit', snippetType = 'autosnippet' }, { t('\\textit{'), i(1, 'text'), t('}') }),
    s({ trig = 'texttt', snippetType = 'autosnippet' }, { t('\\texttt{'), i(1, 'text'), t('}') }),
    
    -- Environments
    s({ trig = 'begin', snippetType = 'autosnippet' }, { 
        t('\\begin{'), i(1, 'environment'), t({ '}', '\t' }), 
        i(2), 
        t({ '', '\\end{' }), i(3, 'environment'), t('}') 
    }),
    s({ trig = 'equation', snippetType = 'autosnippet' }, { 
        t('\\begin{equation}'), t({ '', '\t' }), 
        i(1, 'E = mc^2'), 
        t({ '', '\\end{equation}' }) 
    }),
    s({ trig = 'align', snippetType = 'autosnippet' }, { 
        t('\\begin{align}'), t({ '', '\t' }), 
        i(1), 
        t({ '', '\\end{align}' }) 
    }),
    s({ trig = 'itemize', snippetType = 'autosnippet' }, { 
        t('\\begin{itemize}'), t({ '', '\t\\item ' }), 
        i(1), 
        t({ '', '\\end{itemize}' }) 
    }),
    s({ trig = 'enumerate', snippetType = 'autosnippet' }, { 
        t('\\begin{enumerate}'), t({ '', '\t\\item ' }), 
        i(1), 
        t({ '', '\\end{enumerate}' }) 
    }),
    s({ trig = 'figure', snippetType = 'autosnippet' }, { 
        t('\\begin{figure}[h]'), t({ '', '\t\\centering', '\t\\includegraphics[width=0.8\\textwidth]{' }), 
        i(1, 'path/to/image'), 
        t({ '}', '\t\\caption{' }), 
        i(2, 'Caption'), 
        t({ '}', '\t\\label{fig:' }), 
        i(3, 'label'), 
        t({ '}', '\\end{figure}' }) 
    }),
    s({ trig = 'table', snippetType = 'autosnippet' }, { 
        t('\\begin{table}[h]'), t({ '', '\t\\centering', '\t\\begin{tabular}{' }), 
        i(1, 'c|c|c'), 
        t({ '}', '\t\t' }), 
        i(2), 
        t({ '', '\t\\end{tabular}', '\t\\caption{' }), 
        i(3, 'Caption'), 
        t({ '}', '\t\\label{tab:' }), 
        i(4, 'label'), 
        t({ '}', '\\end{table}' }) 
    }),
    
    -- Document structure
    s({ trig = 'section', snippetType = 'autosnippet' }, { t('\\section{'), i(1, 'Section Title'), t({ '}', '', '' }), i(2) }),
    s({ trig = 'subsection', snippetType = 'autosnippet' }, { t('\\subsection{'), i(1, 'Subsection Title'), t({ '}', '', '' }), i(2) }),
    s({ trig = 'subsubsection', snippetType = 'autosnippet' }, { t('\\subsubsection{'), i(1, 'Subsubsection Title'), t({ '}', '', '' }), i(2) }),
    
    -- References (safe ones)
    s({ trig = 'eqref', snippetType = 'autosnippet' }, { t('\\eqref{'), i(1, 'label'), t('}') }),
    s({ trig = 'label', snippetType = 'autosnippet' }, { t('\\label{'), i(1, 'label'), t('}') }),
    
    -- URLs and links
    s({ trig = 'href', snippetType = 'autosnippet' }, { t('\\href{'), i(1, 'https://example.com'), t('}{'), i(2, 'link text'), t('}') }),
    
    -- Footnotes
    s({ trig = 'footnote', snippetType = 'autosnippet' }, { t('\\footnote{'), i(1, 'footnote text'), t('}') }),
    
    -- Quotes
    s({ trig = 'quote', snippetType = 'autosnippet' }, { 
        t('\\begin{quote}'), t({ '', '\t' }), 
        i(1), 
        t({ '', '\\end{quote}' }) 
    }),
    s({ trig = 'quotation', snippetType = 'autosnippet' }, { 
        t('\\begin{quotation}'), t({ '', '\t' }), 
        i(1), 
        t({ '', '\\end{quotation}' }) 
    }),
    
    -- Code/verbatim
    s({ trig = 'verbatim', snippetType = 'autosnippet' }, { 
        t('\\begin{verbatim}'), t({ '', '\t' }), 
        i(1), 
        t({ '', '\\end{verbatim}' }) 
    }),
    
    -- Math display
    s({ trig = 'display', snippetType = 'autosnippet' }, { t('\\['), i(1), t(' \\]') }),
    s({ trig = 'inline', snippetType = 'autosnippet' }, { t('\\('), i(1), t('\\)') }),
}

-- Math mode auto-expand snippets (only expand in math mode)
local math_autosnippets = {
    -- Greek letters (auto-expand in math mode only)
    s({ trig = 'alpha', snippetType = 'autosnippet', condition = in_mathzone }, t('\\alpha')),
    s({ trig = 'beta', snippetType = 'autosnippet', condition = in_mathzone }, t('\\beta')),
    s({ trig = 'gamma', snippetType = 'autosnippet', condition = in_mathzone }, t('\\gamma')),
    s({ trig = 'delta', snippetType = 'autosnippet', condition = in_mathzone }, t('\\delta')),
    s({ trig = 'epsilon', snippetType = 'autosnippet', condition = in_mathzone }, t('\\epsilon')),
    s({ trig = 'theta', snippetType = 'autosnippet', condition = in_mathzone }, t('\\theta')),
    s({ trig = 'lambda', snippetType = 'autosnippet', condition = in_mathzone }, t('\\lambda')),
    s({ trig = 'mu', snippetType = 'autosnippet', condition = in_mathzone }, t('\\mu')),
    s({ trig = 'pi', snippetType = 'autosnippet', condition = in_mathzone }, t('\\pi')),
    s({ trig = 'sigma', snippetType = 'autosnippet', condition = in_mathzone }, t('\\sigma')),
    s({ trig = 'phi', snippetType = 'autosnippet', condition = in_mathzone }, t('\\phi')),
    s({ trig = 'omega', snippetType = 'autosnippet', condition = in_mathzone }, t('\\omega')),
    
    -- Capital Greek letters
    s({ trig = 'Delta', snippetType = 'autosnippet', condition = in_mathzone }, t('\\Delta')),
    s({ trig = 'Gamma', snippetType = 'autosnippet', condition = in_mathzone }, t('\\Gamma')),
    s({ trig = 'Lambda', snippetType = 'autosnippet', condition = in_mathzone }, t('\\Lambda')),
    s({ trig = 'Pi', snippetType = 'autosnippet', condition = in_mathzone }, t('\\Pi')),
    s({ trig = 'Sigma', snippetType = 'autosnippet', condition = in_mathzone }, t('\\Sigma')),
    s({ trig = 'Phi', snippetType = 'autosnippet', condition = in_mathzone }, t('\\Phi')),
    s({ trig = 'Omega', snippetType = 'autosnippet', condition = in_mathzone }, t('\\Omega')),
    
    -- Fractions
    s({ trig = 'frac', snippetType = 'autosnippet', condition = in_mathzone }, { 
        t('\\frac{'), i(1, 'numerator'), t('}{'), i(2, 'denominator'), t('}') 
    }),
    
    -- Sum, product, integral
    s({ trig = 'sum', snippetType = 'autosnippet', condition = in_mathzone }, { 
        t('\\sum_{'), i(1, 'i=1'), t('}^{'), i(2, 'n'), t('}') 
    }),
    s({ trig = 'prod', snippetType = 'autosnippet', condition = in_mathzone }, { 
        t('\\prod_{'), i(1, 'i=1'), t('}^{'), i(2, 'n'), t('}') 
    }),
    s({ trig = 'int', snippetType = 'autosnippet', condition = in_mathzone }, { 
        t('\\int_{'), i(1, 'a'), t('}^{'), i(2, 'b'), t('}') 
    }),
    
    -- Math operators (safe ones)
    s({ trig = 'cdot', snippetType = 'autosnippet', condition = in_mathzone }, t('\\cdot')),
    s({ trig = 'pm', snippetType = 'autosnippet', condition = in_mathzone }, t('\\pm')),
    s({ trig = 'mp', snippetType = 'autosnippet', condition = in_mathzone }, t('\\mp')),
    s({ trig = 'leq', snippetType = 'autosnippet', condition = in_mathzone }, t('\\leq')),
    s({ trig = 'geq', snippetType = 'autosnippet', condition = in_mathzone }, t('\\geq')),
    s({ trig = 'neq', snippetType = 'autosnippet', condition = in_mathzone }, t('\\neq')),
    s({ trig = 'approx', snippetType = 'autosnippet', condition = in_mathzone }, t('\\approx')),
    s({ trig = 'equiv', snippetType = 'autosnippet', condition = in_mathzone }, t('\\equiv')),
    s({ trig = 'notin', snippetType = 'autosnippet', condition = in_mathzone }, t('\\notin')),
    s({ trig = 'subset', condition = in_mathzone }, t('\\subset')),
    s({ trig = 'subseteq', snippetType = 'autosnippet', condition = in_mathzone }, t('\\subseteq')),
    s({ trig = 'superset', condition = in_mathzone }, t('\\supset')),
    s({ trig = 'supseteq', snippetType = 'autosnippet', condition = in_mathzone }, t('\\supseteq')),
    
    -- Sets
    s({ trig = 'emptyset', snippetType = 'autosnippet', condition = in_mathzone }, t('\\emptyset')),
    s({ trig = 'mathbb', snippetType = 'autosnippet', condition = in_mathzone }, { 
        t('\\mathbb{'), i(1, 'R'), t('}') 
    }),
    
    -- Vectors and matrices
    s({ trig = 'det', snippetType = 'autosnippet', condition = in_mathzone }, { 
        t('\\det\\begin{pmatrix}'), t({ '', '\t' }), 
        i(1, 'a & b \\\\ c & d'), 
        t({ '', '\\end{pmatrix}' }) 
    }),
    
    -- Limits
    s({ trig = 'limsup', snippetType = 'autosnippet', condition = in_mathzone }, { 
        t('\\limsup_{'), i(1, 'n \\to \\infty'), t('}') 
    }),
    s({ trig = 'liminf', snippetType = 'autosnippet', condition = in_mathzone }, { 
        t('\\liminf_{'), i(1, 'n \\to \\infty'), t('}') 
    }),
    
    -- Derivatives
    s({ trig = 'pd', snippetType = 'autosnippet', condition = in_mathzone }, { 
        t('\\frac{\\partial '), i(1, 'f'), t('}{\\partial '), i(2, 'x'), t('}') 
    }),
    s({ trig = 'dd', snippetType = 'autosnippet', condition = in_mathzone }, { 
        t('\\frac{\\mathrm{d}'), i(1, 'f'), t('}{\\mathrm{d}'), i(2, 'x'), t('}') 
    }),
    
    -- Common symbols
    s({ trig = 'infty', snippetType = 'autosnippet', condition = in_mathzone }, t('\\infty')),
    s({ trig = 'partial', snippetType = 'autosnippet', condition = in_mathzone }, t('\\partial')),
    s({ trig = 'nabla', snippetType = 'autosnippet', condition = in_mathzone }, t('\\nabla')),
    s({ trig = 'forall', snippetType = 'autosnippet', condition = in_mathzone }, t('\\forall')),
    s({ trig = 'exists', snippetType = 'autosnippet', condition = in_mathzone }, t('\\exists')),
    s({ trig = 'lnot', snippetType = 'autosnippet', condition = in_mathzone }, t('\\lnot')),
    s({ trig = 'implies', snippetType = 'autosnippet', condition = in_mathzone }, t('\\implies')),
    s({ trig = 'iff', snippetType = 'autosnippet', condition = in_mathzone }, t('\\iff')),
    s({ trig = 'setminus', snippetType = 'autosnippet', condition = in_mathzone }, t('\\setminus')),
    s({ trig = 'oplus', snippetType = 'autosnippet', condition = in_mathzone }, t('\\oplus')),
    s({ trig = 'otimes', snippetType = 'autosnippet', condition = in_mathzone }, t('\\otimes')),
    s({ trig = 'odot', snippetType = 'autosnippet', condition = in_mathzone }, t('\\odot')),
}

-- ============================================================================
-- NON-AUTO-EXPAND SNIPPETS (Require manual Tab expansion to avoid mistakes)
-- ============================================================================

-- Math mode snippets (non-auto-expand, could be part of words)
-- These require manual Tab expansion and only work in math mode
local math_snippets = {
    -- Math operators (common words)
    s({ trig = 'times', condition = in_mathzone }, t('\\times')),
    s({ trig = 'div', condition = in_mathzone }, t('\\div')),
    s({ trig = 'in', condition = in_mathzone }, t('\\in')),
    
    -- Sets and vectors (common words)
    s({ trig = 'set', condition = in_mathzone }, { t('\\{'), i(1, 'elements'), t('\\}') }),
    s({ trig = 'vec', condition = in_mathzone }, { t('\\vec{'), i(1, 'v'), t('}') }),
    s({ trig = 'mat', condition = in_mathzone }, { 
        t('\\begin{pmatrix}'), t({ '', '\t' }), 
        i(1, 'a & b \\\\ c & d'), 
        t({ '', '\\end{pmatrix}' }) 
    }),
    
    -- Limits
    s({ trig = 'lim', condition = in_mathzone }, { t('\\lim_{'), i(1, 'x \\to \\infty'), t('}') }),
    
    -- Logic operators (common words)
    s({ trig = 'land', condition = in_mathzone }, t('\\land')),
    s({ trig = 'lor', condition = in_mathzone }, t('\\lor')),
    s({ trig = 'cup', condition = in_mathzone }, t('\\cup')),
    s({ trig = 'cap', condition = in_mathzone }, t('\\cap')),
}

-- Text mode snippets (non-auto-expand, could be part of words)
local text_snippets = {
    -- References (could be part of words)
    s('ref', { t('\\ref{'), i(1, 'label'), t('}') }),
    s('cite', { t('\\cite{'), i(1, 'key'), t('}') }),
    
    -- Lists
    s('item', { t('\\item '), i(1) }),
    
    -- URLs and links
    s('url', { t('\\url{'), i(1, 'https://example.com'), t('}') }),
    
    -- Code/verbatim
    s('verb', { t('\\verb|'), i(1), t('|') }),
}

-- Combine all snippet groups into a single table
local all_snippets = {}
vim.list_extend(all_snippets, text_autosnippets)
vim.list_extend(all_snippets, math_autosnippets)
vim.list_extend(all_snippets, math_snippets)
vim.list_extend(all_snippets, text_snippets)

-- Register all snippets
ls.add_snippets('tex', all_snippets)

-- Note: LuaSnip will automatically make these snippets available for both
-- 'tex' and 'plaintex' filetypes, so no additional registration is needed
