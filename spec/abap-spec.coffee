describe "Abap grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-abap")

    runs ->
      grammar = atom.syntax.grammarForScopeName("source.abp")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.abp"

  describe "comments", ->
    it "tokenizes comment line", ->
      {tokens} = grammar.tokenizeLine('              "line comment')
      expect(tokens[1]).toEqual value: '"line comment', scopes: ['source.abp', 'comment.line.abp']

    it "tokenizes comment block", ->
      {tokens} = grammar.tokenizeLine('*block comment')
      expect(tokens[0]).toEqual value: '*block comment', scopes: ['source.abp', 'comment.block.abp']

  describe "types", ->
    it "tokenizes numbers", ->
      {tokens} = grammar.tokenizeLine('25')
      expect(tokens[0]).toEqual value: '25', scopes: ['source.abp', 'constant.numeric.abp']

    it "tokenizes text symbols", ->
      {tokens} = grammar.tokenizeLine('text-001')
      expect(tokens[0]).toEqual value: 'text-001', scopes: ['source.abp', 'constant.character.escape.abp']

    it "tokenizes string constants", ->
      {tokens} = grammar.tokenizeLine('\'text\'')
      expect(tokens[0]).toEqual value: '\'', scopes: ['source.abp', 'string.quoted.single.abp', 'punctuation.definition.string.begin.abp']
      expect(tokens[1]).toEqual value: 'text', scopes: ['source.abp', 'string.quoted.single.abp']
      expect(tokens[2]).toEqual value: '\'', scopes: ['source.abp', 'string.quoted.single.abp', 'punctuation.definition.string.end.abp']

  describe "keywords", ->
    it "tokenizes multi-word keywords", ->
      {tokens} = grammar.tokenizeLine('add-corresponding')
      expect(tokens[0]).toEqual value: 'add-corresponding', scopes: ['source.abp', 'keyword.control.abp']

    it "tokenizes simple keywords", ->
      {tokens} = grammar.tokenizeLine('append')
      expect(tokens[0]).toEqual value: 'append', scopes: ['source.abp', 'keyword.control.abp']

    it "tokenizes multi-word keywords", ->
      {tokens} = grammar.tokenizeLine('add-corresponding')
      expect(tokens[0]).toEqual value: 'add-corresponding', scopes: ['source.abp', 'keyword.control.abp']

    it "tokenizes operators", ->
      {tokens} = grammar.tokenizeLine('ne')
      expect(tokens[0]).toEqual value: 'ne', scopes: ['source.abp', 'keyword.control.abp']

      {tokens} = grammar.tokenizeLine('type')
      expect(tokens[0]).toEqual value: 'type', scopes: ['source.abp', 'keyword.control.abp']

    it "tokenizes basic data types", ->
      {tokens} = grammar.tokenizeLine('type i')
      expect(tokens[0]).toEqual value: 'type i', scopes: ['source.abp', 'keyword.control.abp']

  describe "subrutines", ->
    it "tokenizes forms declarations", ->
      {tokens} = grammar.tokenizeLine('form foo.')
      expect(tokens[0]).toEqual value: 'form', scopes: ['source.abp', 'entity.name.function.abp', 'storage.type.abp']
      #tokens[1] is a separator
      expect(tokens[2]).toEqual value: 'foo', scopes: ['source.abp', 'entity.name.function.abp', 'entity.name.function.abp']

    it "tokenizes functions declarations", ->
      {tokens} = grammar.tokenizeLine('function foo.')
      expect(tokens[0]).toEqual value: 'function', scopes: ['source.abp', 'entity.name.function.abp', 'storage.type.abp']
      #tokens[1] is a separator
      expect(tokens[2]).toEqual value: 'foo', scopes: ['source.abp', 'entity.name.function.abp', 'entity.name.function.abp']

    it "tokenizes method definitions", ->
      {tokens} = grammar.tokenizeLine('method foo.')
      expect(tokens[0]).toEqual value: 'method', scopes: ['source.abp', 'entity.name.function.abp', 'storage.type.abp']
      #tokens[1] is a separator
      expect(tokens[2]).toEqual value: 'foo', scopes: ['source.abp', 'entity.name.function.abp', 'entity.name.function.abp']

    it "tokenizes module definitions", ->
      {tokens} = grammar.tokenizeLine('module foo output.')
      expect(tokens[0]).toEqual value: 'module', scopes: ['source.abp', 'entity.name.type.instance.abp', 'storage.type.abp']
      #tokens[1] is a separator
      expect(tokens[2]).toEqual value: 'foo', scopes: ['source.abp', 'entity.name.type.instance.abp', 'entity.name.type.instance.abp']
      #tokens[3] is a separator
      expect(tokens[4]).toEqual value: 'output', scopes: ['source.abp', 'entity.name.type.instance.abp', 'keyword.control.abp']

    it "tokenizes subrutines end", ->
      {tokens} = grammar.tokenizeLine('endfunction.')
      expect(tokens[0]).toEqual value: 'endfunction', scopes: ['source.abp', 'storage.type.abp']
