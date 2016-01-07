node missing1 {
  notify {'a':
    require => Notify['b'],
  }
}

node missing2 {
  notify {'a': }
  Notify['b'] -> Notify['a']
}
