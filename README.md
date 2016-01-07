# PUP-5659

[PUP-5659](https://tickets.puppetlabs.com/browse/PUP-5659)

site.pp:
```
node missing1 {
  notify {'a':
    require => Notify['b'],
  }
}

node missing2 {
  notify {'a': }
  Notify['b'] -> Notify['a']
}
```

## Example 1 (bug)

This should fail but does not:
```
$ puppet master --environmentpath=. --compile=missing1.examble.com
Warning: Host is missing hostname and/or domain: missing1.examble.com
Notice: Compiled catalog for missing1.examble.com in environment production in 0.03 seconds
{
  "tags": ["settings","missing1","node"],
  "name": "missing1.examble.com",
  "version": 1452179847,
  "code_id": null,
  "environment": "production",
  "resources": [
    {
      "type": "Stage",
      "title": "main",
      "tags": ["stage"],
      "exported": false,
      "parameters": {
        "name": "main"
      }
    },
    {
      "type": "Class",
      "title": "Settings",
      "tags": ["class","settings"],
      "exported": false
    },
    {
      "type": "Class",
      "title": "main",
      "tags": ["class"],
      "exported": false,
      "parameters": {
        "name": "main"
      }
    },
    {
      "type": "Node",
      "title": "missing1",
      "tags": ["node","missing1","class"],
      "exported": false
    },
    {
      "type": "Notify",
      "title": "a",
      "tags": ["notify","a","node","missing1","class"],
      "file": "/home/roidelapluie/dev/poc/production/manifests/site.pp",
      "line": 2,
      "exported": false,
      "parameters": {
        "require": "Notify[b]"
      }
    }
  ],
  "edges": [
    {
      "source": "Stage[main]",
      "target": "Class[Settings]"
    },
    {
      "source": "Stage[main]",
      "target": "Class[main]"
    },
    {
      "source": "Class[main]",
      "target": "Node[missing1]"
    },
    {
      "source": "Node[missing1]",
      "target": "Notify[a]"
    }
  ],
  "classes": [
    "settings",
    "missing1"
  ]
}
$ echo $?
0
```

## Example 2 (not a bug)

This fails as expected:
```
$ puppet master --environmentpath=. --compile=missing2.examble.com
Warning: Host is missing hostname and/or domain: missing2.examble.com
Error: Could not find resource 'Notify[b]' for relationship on 'Notify[a]' on node missing2.examble.com
Error: Could not find resource 'Notify[b]' for relationship on 'Notify[a]' on node missing2.examble.com
Error: Failed to compile catalog for node missing2.examble.com: Could not find resource 'Notify[b]' for relationship on 'Notify[a]' on node missing2.examble.com
$ echo $?
30
```

