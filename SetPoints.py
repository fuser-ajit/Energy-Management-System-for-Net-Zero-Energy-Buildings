class CoolingSetpointScheduleType(GeneratedsSuper):
    """Cooling setpoint schedule [degrees F] The value must be a comma-
    separated list of hourly values (24 numbers) or weekday/weekend
    hourly values (48 numbers)."""
    subclass = None
    superclass = None
    def __init__(self, item=None):
        if item is None:
            self.item = SuperList()
        else:
            self.item = item
    def factory(*args_, **kwargs_):
        if CoolingSetpointScheduleType.subclass:
            return CoolingSetpointScheduleType.subclass(*args_, **kwargs_)
        else:
            return CoolingSetpointScheduleType(*args_, **kwargs_)
    factory = staticmethod(factory)
    def get_item(self): return self.item
    def set_item(self, item): self.item = item
    def add_item(self, value): self.item.append(value)
    def insert_item(self, index, value): self.item[index] = value
    def export(self, outfile, level, namespace_='', name_='CoolingSetpointScheduleType', namespacedef_=''):
        showIndent(outfile, level)
        outfile.write('<%s%s%s' % (namespace_, name_, namespacedef_ and ' ' + namespacedef_ or '', ))
        already_processed = SuperList()
        self.exportAttributes(outfile, level, already_processed, namespace_, name_='CoolingSetpointScheduleType')
        if self.hasContent_():
            outfile.write('>\n')
            self.exportChildren(outfile, level + 1, namespace_, name_)
            showIndent(outfile, level)
            outfile.write('</%s%s>\n' % (namespace_, name_))
        else:
            outfile.write('/>\n')
    def exportAttributes(self, outfile, level, already_processed, namespace_='', name_='CoolingSetpointScheduleType'):
        pass
    def exportChildren(self, outfile, level, namespace_='', name_='CoolingSetpointScheduleType', fromsubclass_=False):
        for _item in self.item:
            showIndent(outfile, level)
            outfile.write('<%sitem>%s</%sitem>\n' % (namespace_, self.gds_format_float(_item, input_name='item'), namespace_))
    def hasContent_(self):
        if (
            self.item
            ):
            return True
        else:
            return False
    def exportLiteral(self, outfile, level, name_='CoolingSetpointScheduleType'):
        level += 1
        self.exportLiteralAttributes(outfile, level, [], name_)
        if self.hasContent_():
            self.exportLiteralChildren(outfile, level, name_)
    def exportLiteralAttributes(self, outfile, level, already_processed, name_):
        pass
    def exportLiteralChildren(self, outfile, level, name_):
        showIndent(outfile, level)
        outfile.write('item=[\n')
        level += 1
        for _item in self.item:
            showIndent(outfile, level)
            outfile.write('%f,\n' % _item)
        level -= 1
        showIndent(outfile, level)
        outfile.write('],\n')
    def build(self, node):
        self.buildAttributes(node, node.attrib, [])
        for child in node:
            nodeName_ = Tag_pattern_.match(child.tag).groups()[-1]
            self.buildChildren(child, node, nodeName_)
    def buildAttributes(self, node, attrs, already_processed):
        pass
    def buildChildren(self, child_, node, nodeName_, fromsubclass_=False):
        if nodeName_ == 'item':
            sval_ = child_.text
            try:
                fval_ = float(sval_)
            except (TypeError, ValueError), exp:
                raise_parse_error(child_, 'requires float or double: %s' % exp)
            fval_ = self.gds_validate_float(fval_, node, 'item')
            self.item.append(fval_)
# end class CoolingSetpointScheduleType


class CoolingSetpointDRScheduleType(GeneratedsSuper):
    """The cooling set point schedule for houses that employ demand
    response (DR). The actual schedule for a demand response event
    will combine the non-DR and DR schedules using the penetration
    rate. [degrees F] The value must be a comma-separated list of
    hourly values (24 numbers) or weekday/weekend hourly values (48
    numbers)."""
    subclass = None
    superclass = None
    def __init__(self, item=None):
        if item is None:
            self.item = SuperList()
        else:
            self.item = item
    def factory(*args_, **kwargs_):
        if CoolingSetpointDRScheduleType.subclass:
            return CoolingSetpointDRScheduleType.subclass(*args_, **kwargs_)
        else:
            return CoolingSetpointDRScheduleType(*args_, **kwargs_)
    factory = staticmethod(factory)
    def get_item(self): return self.item
    def set_item(self, item): self.item = item
    def add_item(self, value): self.item.append(value)
    def insert_item(self, index, value): self.item[index] = value
    def export(self, outfile, level, namespace_='', name_='CoolingSetpointDRScheduleType', namespacedef_=''):
        showIndent(outfile, level)
        outfile.write('<%s%s%s' % (namespace_, name_, namespacedef_ and ' ' + namespacedef_ or '', ))
        already_processed = SuperList()
        self.exportAttributes(outfile, level, already_processed, namespace_, name_='CoolingSetpointDRScheduleType')
        if self.hasContent_():
            outfile.write('>\n')
            self.exportChildren(outfile, level + 1, namespace_, name_)
            showIndent(outfile, level)
            outfile.write('</%s%s>\n' % (namespace_, name_))
        else:
            outfile.write('/>\n')
    def exportAttributes(self, outfile, level, already_processed, namespace_='', name_='CoolingSetpointDRScheduleType'):
        pass
    def exportChildren(self, outfile, level, namespace_='', name_='CoolingSetpointDRScheduleType', fromsubclass_=False):
        for _item in self.item:
            showIndent(outfile, level)
            outfile.write('<%sitem>%s</%sitem>\n' % (namespace_, self.gds_format_float(_item, input_name='item'), namespace_))
    def hasContent_(self):
        if (
            self.item
            ):
            return True
        else:
            return False
    def exportLiteral(self, outfile, level, name_='CoolingSetpointDRScheduleType'):
        level += 1
        self.exportLiteralAttributes(outfile, level, [], name_)
        if self.hasContent_():
            self.exportLiteralChildren(outfile, level, name_)
    def exportLiteralAttributes(self, outfile, level, already_processed, name_):
        pass
    def exportLiteralChildren(self, outfile, level, name_):
        showIndent(outfile, level)
        outfile.write('item=[\n')
        level += 1
        for _item in self.item:
            showIndent(outfile, level)
            outfile.write('%f,\n' % _item)
        level -= 1
        showIndent(outfile, level)
        outfile.write('],\n')
    def build(self, node):
        self.buildAttributes(node, node.attrib, [])
        for child in node:
            nodeName_ = Tag_pattern_.match(child.tag).groups()[-1]
            self.buildChildren(child, node, nodeName_)
    def buildAttributes(self, node, attrs, already_processed):
        pass
    def buildChildren(self, child_, node, nodeName_, fromsubclass_=False):
        if nodeName_ == 'item':
            sval_ = child_.text
            try:
                fval_ = float(sval_)
            except (TypeError, ValueError), exp:
                raise_parse_error(child_, 'requires float or double: %s' % exp)
            fval_ = self.gds_validate_float(fval_, node, 'item')
            self.item.append(fval_)
# end class CoolingSetpointDRScheduleType


class HeatingSetpointScheduleType(GeneratedsSuper):
    """Heating setpoint schedule. [degrees F] The value must be a comma-
    separated list of hourly values (24 numbers) or weekday/weekend
    hourly values (48 numbers)."""
    subclass = None
    superclass = None
    def __init__(self, item=None):
        if item is None:
            self.item = SuperList()
        else:
            self.item = item
    def factory(*args_, **kwargs_):
        if HeatingSetpointScheduleType.subclass:
            return HeatingSetpointScheduleType.subclass(*args_, **kwargs_)
        else:
            return HeatingSetpointScheduleType(*args_, **kwargs_)
    factory = staticmethod(factory)
    def get_item(self): return self.item
    def set_item(self, item): self.item = item
    def add_item(self, value): self.item.append(value)
    def insert_item(self, index, value): self.item[index] = value
    def export(self, outfile, level, namespace_='', name_='HeatingSetpointScheduleType', namespacedef_=''):
        showIndent(outfile, level)
        outfile.write('<%s%s%s' % (namespace_, name_, namespacedef_ and ' ' + namespacedef_ or '', ))
        already_processed = SuperList()
        self.exportAttributes(outfile, level, already_processed, namespace_, name_='HeatingSetpointScheduleType')
        if self.hasContent_():
            outfile.write('>\n')
            self.exportChildren(outfile, level + 1, namespace_, name_)
            showIndent(outfile, level)
            outfile.write('</%s%s>\n' % (namespace_, name_))
        else:
            outfile.write('/>\n')
    def exportAttributes(self, outfile, level, already_processed, namespace_='', name_='HeatingSetpointScheduleType'):
        pass
    def exportChildren(self, outfile, level, namespace_='', name_='HeatingSetpointScheduleType', fromsubclass_=False):
        for _item in self.item:
            showIndent(outfile, level)
            outfile.write('<%sitem>%s</%sitem>\n' % (namespace_, self.gds_format_float(_item, input_name='item'), namespace_))
    def hasContent_(self):
        if (
            self.item
            ):
            return True
        else:
            return False
    def exportLiteral(self, outfile, level, name_='HeatingSetpointScheduleType'):
        level += 1
        self.exportLiteralAttributes(outfile, level, [], name_)
        if self.hasContent_():
            self.exportLiteralChildren(outfile, level, name_)
    def exportLiteralAttributes(self, outfile, level, already_processed, name_):
        pass
    def exportLiteralChildren(self, outfile, level, name_):
        showIndent(outfile, level)
        outfile.write('item=[\n')
        level += 1
        for _item in self.item:
            showIndent(outfile, level)
            outfile.write('%f,\n' % _item)
        level -= 1
        showIndent(outfile, level)
        outfile.write('],\n')
    def build(self, node):
        self.buildAttributes(node, node.attrib, [])
        for child in node:
            nodeName_ = Tag_pattern_.match(child.tag).groups()[-1]
            self.buildChildren(child, node, nodeName_)
    def buildAttributes(self, node, attrs, already_processed):
        pass
    def buildChildren(self, child_, node, nodeName_, fromsubclass_=False):
        if nodeName_ == 'item':
            sval_ = child_.text
            try:
                fval_ = float(sval_)
            except (TypeError, ValueError), exp:
                raise_parse_error(child_, 'requires float or double: %s' % exp)
            fval_ = self.gds_validate_float(fval_, node, 'item')
            self.item.append(fval_)
# end class HeatingSetpointScheduleType

