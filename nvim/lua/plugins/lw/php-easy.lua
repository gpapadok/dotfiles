return {
  'ta-tikoma/php.easy.nvim',
  config = true,
  keys = {
    { '-#', '<cmd>PHPEasyAttribute<cr>', desc = 'PHPEasy Attribute', ft = 'php' },
    { '-b', '<cmd>PHPEasyDocBlock<cr>', desc = 'PHPEasy Doc Block', ft = 'php' },
    { '-r', '<cmd>PHPEasyReplica<cr>', desc = 'PHPEasy Replica', ft = 'php' },
    { '-c', '<cmd>PHPEasyCopy<cr>', desc = 'PHPEasy Copy', ft = 'php' },
    { '-d', '<cmd>PHPEasyDelete<cr>', desc = 'PHPEasy Delete', ft = 'php' },
    { '-uu', '<cmd>PHPEasyRemoveUnusedUses<cr>', desc = 'PHPEasy Remove Unused Uses', ft = 'php' },
    { '-e', '<cmd>PHPEasyExtends<cr>', desc = 'PHPEasy Extends', ft = 'php' },
    { '-i', '<cmd>PHPEasyImplements<cr>', desc = 'PHPEasy Implements', ft = 'php' },

    { '--i', '<cmd>PHPEasyInitInterface<cr>', desc = 'PHPEasy Init Interface', ft = 'php' },
    { '--c', '<cmd>PHPEasyInitClass<cr>', desc = 'PHPEasy Init Class', ft = 'php' },
    { '--ac', '<cmd>PHPEasyInitAbstractClass<cr>', desc = 'PHPEasy Init Abstract Class', ft = 'php' },
    { '--t', '<cmd>PHPEasyInitTrait<cr>', desc = 'PHPEasy Init Trait', ft = 'php' },
    { '--e', '<cmd>PHPEasyInitEnum<cr>', desc = 'PHPEasy Init Enum', ft = 'php' },

    -- { '_c', '<cmd>PHPEasyAppendConstant<cr>', desc = 'PHPEasy Append Constant', ft = 'php', mode = { 'n', 'v' } },
    { '-p', '<cmd>PHPEasyAppendProperty<cr>', desc = 'PHPEasy Append Property', ft = 'php', mode = { 'n', 'v' } },
    { '-m', '<cmd>PHPEasyAppendMethod<cr>', desc = 'PHPEasy Append Method', ft = 'php', mode = { 'n', 'v' } },
    -- { '__', '<cmd>PHPEasyAppendConstruct<cr>', desc = 'PHPEasy Append Construct', ft = 'php' },
    -- { '_i', '<cmd>PHPEasyAppendInvoke<cr>', desc = 'PHPEasy Append Invoke', ft = 'php' },
    { '-a', '<cmd>PHPEasyAppendArgument<cr>', desc = 'PHPEasy Append Argument', ft = 'php' },
  },
}
