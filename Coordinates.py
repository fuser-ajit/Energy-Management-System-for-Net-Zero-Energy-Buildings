class coord(GeneratedsSuper):
    subclass = None
    superclass = None
    def __init__(self, y=None, x=None, z=None):
        self.y = _cast(float, y)
        self.x = _cast(float, x)
        self.z = _cast(float, z)
        pass
    def factory(*args_, **kwargs_):
        if coord.subclass:
            return coord.subclass(*args_, **kwargs_)
        else:
            return coord(*args_, **kwargs_)
    factory = staticmethod(factory)
    def get_y(self): return self.y
    def set_y(self, y): self.y = y
    def get_x(self): return self.x
    def set_x(self, x): self.x = x
    def get_z(self): return self.z
    def set_z(self, z): self.z = z
    def export(self, outfile, level, namespace_='', name_='coord', namespacedef_=''):
        showIndent(outfile, level)
        outfile.write('<%s%s%s' % (namespace_, name_, namespacedef_ and ' ' + namespacedef_ or '', ))
        already_processed = SuperList()
        self.exportAttributes(outfile, level, already_processed, namespace_, name_='coord')
        if self.hasContent_():
            outfile.write('>\n')
            self.exportChildren(outfile, level + 1, namespace_, name_)
            outfile.write('</%s%s>\n' % (namespace_, name_))
        else:
            outfile.write('/>\n')
    def exportAttributes(self, outfile, level, already_processed, namespace_='', name_='coord'):
        if self.y is not None and 'y' not in already_processed:
            already_processed.append('y')
            outfile.write(' %sy="%s"' % (namespace_,self.gds_format_float(self.y, input_name='y')))
        if self.x is not None and 'x' not in already_processed:
            already_processed.append('x')
            outfile.write(' %sx="%s"' % (namespace_,self.gds_format_float(self.x, input_name='x')))
        if self.z is not None and 'z' not in already_processed:
            already_processed.append('z')
            outfile.write(' %sz="%s"' % (namespace_,self.gds_format_float(self.z, input_name='z')))
    def exportChildren(self, outfile, level, namespace_='', name_='coord', fromsubclass_=False):
        pass
    def hasContent_(self):
        if (

            ):
            return True
        else:
            return False
    def exportLiteral(self, outfile, level, name_='coord'):
        level += 1
        self.exportLiteralAttributes(outfile, level, [], name_)
        if self.hasContent_():
            self.exportLiteralChildren(outfile, level, name_)
    def exportLiteralAttributes(self, outfile, level, already_processed, name_):
        if self.y is not None and 'y' not in already_processed:
            already_processed.append('y')
            showIndent(outfile, level)
            outfile.write('y = %f,\n' % (self.y,))
        if self.x is not None and 'x' not in already_processed:
            already_processed.append('x')
            showIndent(outfile, level)
            outfile.write('x = %f,\n' % (self.x,))
        if self.z is not None and 'z' not in already_processed:
            already_processed.append('z')
            showIndent(outfile, level)
            outfile.write('z = %f,\n' % (self.z,))
    def exportLiteralChildren(self, outfile, level, name_):
        pass
    def build(self, node):
        self.buildAttributes(node, node.attrib, [])
        for child in node:
            nodeName_ = Tag_pattern_.match(child.tag).groups()[-1]
            self.buildChildren(child, node, nodeName_)
    def buildAttributes(self, node, attrs, already_processed):
        value = find_attr_value_('y', node)
        if value is not None and 'y' not in already_processed:
            already_processed.append('y')
            try:
                self.y = float(value)
            except ValueError, exp:
                raise ValueError('Bad float/double attribute (y): %s' % exp)
        value = find_attr_value_('x', node)
        if value is not None and 'x' not in already_processed:
            already_processed.append('x')
            try:
                self.x = float(value)
            except ValueError, exp:
                raise ValueError('Bad float/double attribute (x): %s' % exp)
        value = find_attr_value_('z', node)
        if value is not None and 'z' not in already_processed:
            already_processed.append('z')
            try:
                self.z = float(value)
            except ValueError, exp:
                raise ValueError('Bad float/double attribute (z): %s' % exp)
    def buildChildren(self, child_, node, nodeName_, fromsubclass_=False):
        pass
# end class coord
