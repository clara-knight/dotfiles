-- LaTeX snippets for LuaSnip
local luasnip = require('luasnip')
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local sn = luasnip.snippet_node
local c = luasnip.choice_node

-- Helper function to create formatted snippets without fmt
local function make_snippet(trigger, text, insert_positions)
    local nodes = {}
    local pos = 1
    local insert_idx = 1
    
    for placeholder in text:gmatch('{}') do
        local before = text:sub(pos, text:find('{}', pos) - 1)
        if before ~= '' then
            table.insert(nodes, t(before))
        end
        if insert_positions and insert_positions[insert_idx] then
            table.insert(nodes, i(insert_idx, insert_positions[insert_idx]))
        else
            table.insert(nodes, i(insert_idx))
        end
        pos = text:find('{}', pos) + 2
        insert_idx = insert_idx + 1
    end
    local after = text:sub(pos)
    if after ~= '' then
        table.insert(nodes, t(after))
    end
    
    return s(trigger, nodes)
end

-- Math mode snippets
luasnip.add_snippets('tex', {
    -- Fractions
    s('frac', { t('\\frac{'), i(1, 'numerator'), t('}{'), i(2, 'denominator'), t('}') }),
    
    -- Sum, product, integral
    s('sum', { t('\\sum_{'), i(1, 'i=1'), t('}^{'), i(2, 'n'), t('}') }),
    s('prod', { t('\\prod_{'), i(1, 'i=1'), t('}^{'), i(2, 'n'), t('}') }),
    s('int', { t('\\int_{'), i(1, 'a'), t('}^{'), i(2, 'b'), t('}') }),
    
    -- Greek letters (common ones)
    s('alpha', t('\\alpha')),
    s('beta', t('\\beta')),
    s('gamma', t('\\gamma')),
    s('delta', t('\\delta')),
    s('epsilon', t('\\epsilon')),
    s('theta', t('\\theta')),
    s('lambda', t('\\lambda')),
    s('mu', t('\\mu')),
    s('pi', t('\\pi')),
    s('sigma', t('\\sigma')),
    s('phi', t('\\phi')),
    s('omega', t('\\omega')),
    
    -- Capital Greek letters
    s('Delta', t('\\Delta')),
    s('Gamma', t('\\Gamma')),
    s('Lambda', t('\\Lambda')),
    s('Pi', t('\\Pi')),
    s('Sigma', t('\\Sigma')),
    s('Phi', t('\\Phi')),
    s('Omega', t('\\Omega')),
    
    -- Math operators
    s('cdot', t('\\cdot')),
    s('times', t('\\times')),
    s('div', t('\\div')),
    s('pm', t('\\pm')),
    s('mp', t('\\mp')),
    s('leq', t('\\leq')),
    s('geq', t('\\geq')),
    s('neq', t('\\neq')),
    s('approx', t('\\approx')),
    s('equiv', t('\\equiv')),
    s('in', t('\\in')),
    s('notin', t('\\notin')),
    s('subset', t('\\subset')),
    s('subseteq', t('\\subseteq')),
    s('superset', t('\\supset')),
    s('supseteq', t('\\supseteq')),
    
    -- Sets
    s('set', { t('\\{'), i(1, 'elements'), t('\\}') }),
    s('emptyset', t('\\emptyset')),
    s('mathbb', { t('\\mathbb{'), i(1, 'R'), t('}') }),
    
    -- Vectors and matrices
    s('vec', { t('\\vec{'), i(1, 'v'), t('}') }),
    s('mat', { 
        t('\\begin{pmatrix}'), t({ '', '\t' }), 
        i(1, 'a & b \\\\ c & d'), 
        t({ '', '\\end{pmatrix}' }) 
    }),
    s('det', { 
        t('\\det\\begin{pmatrix}'), t({ '', '\t' }), 
        i(1, 'a & b \\\\ c & d'), 
        t({ '', '\\end{pmatrix}' }) 
    }),
    
    -- Limits
    s('lim', { t('\\lim_{'), i(1, 'x \\to \\infty'), t('}') }),
    s('limsup', { t('\\limsup_{'), i(1, 'n \\to \\infty'), t('}') }),
    s('liminf', { t('\\liminf_{'), i(1, 'n \\to \\infty'), t('}') }),
    
    -- Derivatives
    s('pd', { t('\\frac{\\partial '), i(1, 'f'), t('}{\\partial '), i(2, 'x'), t('}') }),
    s('dd', { t('\\frac{\\mathrm{d}'), i(1, 'f'), t('}{\\mathrm{d}'), i(2, 'x'), t('}') }),
    
    -- Text mode snippets
    s('emph', { t('\\emph{'), i(1, 'text'), t('}') }),
    s('textbf', { t('\\textbf{'), i(1, 'text'), t('}') }),
    s('textit', { t('\\textit{'), i(1, 'text'), t('}') }),
    s('texttt', { t('\\texttt{'), i(1, 'text'), t('}') }),
    
    -- Environments
    s('begin', { 
        t('\\begin{'), i(1, 'environment'), t({ '}', '\t' }), 
        i(2), 
        t({ '', '\\end{' }), i(3, 'environment'), t('}') 
    }),
    s('equation', { 
        t('\\begin{equation}'), t({ '', '\t' }), 
        i(1, 'E = mc^2'), 
        t({ '', '\\end{equation}' }) 
    }),
    s('align', { 
        t('\\begin{align}'), t({ '', '\t' }), 
        i(1), 
        t({ '', '\\end{align}' }) 
    }),
    s('itemize', { 
        t('\\begin{itemize}'), t({ '', '\t\\item ' }), 
        i(1), 
        t({ '', '\\end{itemize}' }) 
    }),
    s('enumerate', { 
        t('\\begin{enumerate}'), t({ '', '\t\\item ' }), 
        i(1), 
        t({ '', '\\end{enumerate}' }) 
    }),
    s('figure', { 
        t('\\begin{figure}[h]'), t({ '', '\t\\centering', '\t\\includegraphics[width=0.8\\textwidth]{' }), 
        i(1, 'path/to/image'), 
        t({ '}', '\t\\caption{' }), 
        i(2, 'Caption'), 
        t({ '}', '\t\\label{fig:' }), 
        i(3, 'label'), 
        t({ '}', '\\end{figure}' }) 
    }),
    s('table', { 
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
    
    -- References
    s('ref', { t('\\ref{'), i(1, 'label'), t('}') }),
    s('eqref', { t('\\eqref{'), i(1, 'label'), t('}') }),
    s('label', { t('\\label{'), i(1, 'label'), t('}') }),
    s('cite', { t('\\cite{'), i(1, 'key'), t('}') }),
    
    -- Common document elements
    s('section', { t('\\section{'), i(1, 'Section Title'), t({ '}', '', '' }), i(2) }),
    s('subsection', { t('\\subsection{'), i(1, 'Subsection Title'), t({ '}', '', '' }), i(2) }),
    s('subsubsection', { t('\\subsubsection{'), i(1, 'Subsubsection Title'), t({ '}', '', '' }), i(2) }),
    
    -- Lists
    s('item', { t('\\item '), i(1) }),
    
    -- URLs and links
    s('url', { t('\\url{'), i(1, 'https://example.com'), t('}') }),
    s('href', { t('\\href{'), i(1, 'https://example.com'), t('}{'), i(2, 'link text'), t('}') }),
    
    -- Footnotes
    s('footnote', { t('\\footnote{'), i(1, 'footnote text'), t('}') }),
    
    -- Quotes
    s('quote', { 
        t('\\begin{quote}'), t({ '', '\t' }), 
        i(1), 
        t({ '', '\\end{quote}' }) 
    }),
    s('quotation', { 
        t('\\begin{quotation}'), t({ '', '\t' }), 
        i(1), 
        t({ '', '\\end{quotation}' }) 
    }),
    
    -- Code/verbatim
    s('verb', { t('\\verb|'), i(1), t('|') }),
    s('verbatim', { 
        t('\\begin{verbatim}'), t({ '', '\t' }), 
        i(1), 
        t({ '', '\\end{verbatim}' }) 
    }),
    
    -- Math display
    s('display', { t('\\['), i(1), t(' \\]') }),
    s('inline', { t('\\('), i(1), t('\\)') }),
    
    -- Common symbols
    s('infty', t('\\infty')),
    s('partial', t('\\partial')),
    s('nabla', t('\\nabla')),
    s('forall', t('\\forall')),
    s('exists', t('\\exists')),
    s('land', t('\\land')),
    s('lor', t('\\lor')),
    s('lnot', t('\\lnot')),
    s('implies', t('\\implies')),
    s('iff', t('\\iff')),
    s('cup', t('\\cup')),
    s('cap', t('\\cap')),
    s('setminus', t('\\setminus')),
    s('oplus', t('\\oplus')),
    s('otimes', t('\\otimes')),
    s('odot', t('\\odot')),
})

-- Note: LuaSnip will automatically make these snippets available for both
-- 'tex' and 'plaintex' filetypes, so no additional registration is needed
