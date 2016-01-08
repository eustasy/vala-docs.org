namespace DocGen {
    private class PackageVisitor : Valadoc.Api.Visitor {
        public unowned Xml.TextWriter builder { private get; construct; }

        public PackageVisitor (Xml.TextWriter builder) {
            Object (builder: builder);
        }

        public override void visit_tree (Valadoc.Api.Tree tree) {
            assert_not_reached ();
        }

        public override void visit_package (Valadoc.Api.Package package) {
            assert_not_reached ();
        }

        public override void visit_namespace (Valadoc.Api.Namespace namespace) {
            if (write_node_element ("namespace", namespace, true)) {
                write_attribute_list_element (namespace.get_attributes ());
                end_node_element (namespace, true);
            }
        }

        public override void visit_interface (Valadoc.Api.Interface interface) {
            if (write_node_element ("interface", interface, true)) {
                if (interface.get_dbus_name () != null) {
                    check_error_code (builder.write_attribute ("dbus_name", interface.get_dbus_name ()));
                }

                write_attribute_list_element (interface.get_attributes ());
                write_parent_list_element (interface.base_type, interface.get_implemented_interface_list ());
                end_node_element (interface, true);
            }
        }

        public override void visit_class (Valadoc.Api.Class class) {
            if (write_node_element ("class", class, true)) {
                check_error_code (builder.write_attribute ("abstract", class.is_abstract.to_string ()));
                check_error_code (builder.write_attribute ("compact", class.is_compact.to_string ()));
                check_error_code (builder.write_attribute ("fundamental", class.is_fundamental.to_string ()));

                if (class.get_dbus_name () != null) {
                    check_error_code (builder.write_attribute ("dbus_name", class.get_dbus_name ()));
                }

                write_attribute_list_element (class.get_attributes ());
                write_parent_list_element (class.base_type, class.get_implemented_interface_list ());
                end_node_element (class, true);
            }
        }

        public override void visit_struct (Valadoc.Api.Struct struct) {
            if (write_node_element ("struct", struct, true)) {
                write_attribute_list_element (struct.get_attributes ());
                write_parent_list_element (struct.base_type);
                end_node_element (struct, true);
            }
        }

        public override void visit_error_domain (Valadoc.Api.ErrorDomain error_domain) {
            if (write_node_element ("error_domain", error_domain, true)) {
                write_attribute_list_element (error_domain.get_attributes ());
                end_node_element (error_domain, true);
            }
        }

        public override void visit_enum (Valadoc.Api.Enum enum) {
            if (write_node_element ("enum", enum, true)) {
                write_attribute_list_element (enum.get_attributes ());
                end_node_element (enum, true);
            }
        }

        public override void visit_property (Valadoc.Api.Property property) {
            if (write_node_element ("property", property)) {
                check_error_code (builder.write_attribute ("abstract", property.is_abstract.to_string ()));
                check_error_code (builder.write_attribute ("dbus_visible", property.is_dbus_visible.to_string ()));
                check_error_code (builder.write_attribute ("override", property.is_override.to_string ()));
                check_error_code (builder.write_attribute ("virtual", property.is_virtual.to_string ()));

                if (property.getter != null) {
                    check_error_code (builder.write_attribute ("getter_private", property.getter.is_private.to_string ()));
                    check_error_code (builder.write_attribute ("getter_protected", property.getter.is_protected.to_string ()));
                    check_error_code (builder.write_attribute ("getter_public", property.getter.is_public.to_string ()));
                    check_error_code (builder.write_attribute ("getter_get", property.getter.is_get.to_string ()));
                }

                if (property.setter != null) {
                    check_error_code (builder.write_attribute ("getter_private", property.setter.is_private.to_string ()));
                    check_error_code (builder.write_attribute ("getter_protected", property.setter.is_protected.to_string ()));
                    check_error_code (builder.write_attribute ("getter_public", property.setter.is_public.to_string ()));
                    check_error_code (builder.write_attribute ("getter_set", property.setter.is_set.to_string ()));
                    check_error_code (builder.write_attribute ("getter_construct", property.setter.is_construct.to_string ()));
                }

                write_attribute_list_element (property.get_attributes ());
                end_node_element (property);
            }
        }

        public override void visit_constant (Valadoc.Api.Constant constant) {
            if (write_node_element ("constant", constant)) {
                write_attribute_list_element (constant.get_attributes ());
                end_node_element (constant);
            }
        }

        public override void visit_field (Valadoc.Api.Field field) {
            if (write_node_element ("field", field)) {
                write_attribute_list_element (field.get_attributes ());
                end_node_element (field);
            }
        }

        public override void visit_error_code (Valadoc.Api.ErrorCode error_code) {
            if (write_node_element ("error_code", error_code)) {
                write_attribute_list_element (error_code.get_attributes ());
                end_node_element (error_code);
            }
        }

        public override void visit_enum_value (Valadoc.Api.EnumValue enum_value) {
            if (write_node_element ("enum_value", enum_value)) {
                write_attribute_list_element (enum_value.get_attributes ());
                end_node_element (enum_value);
            }
        }

        public override void visit_delegate (Valadoc.Api.Delegate delegate) {
            if (write_node_element ("delegate", delegate)) {
                write_attribute_list_element (delegate.get_attributes ());
                end_node_element (delegate);
            }
        }

        public override void visit_signal (Valadoc.Api.Signal signal) {
            if (write_node_element ("signal", signal)) {
                write_attribute_list_element (signal.get_attributes ());
                end_node_element (signal);
            }
        }

        public override void visit_method (Valadoc.Api.Method method) {
            if (write_node_element ("method", method)) {
                write_attribute_list_element (method.get_attributes ());
                end_node_element (method);
            }
        }

        private bool write_node_element (string type, Valadoc.Api.Symbol symbol, bool is_container = false) {
            if (symbol.name == null) {
                if (is_container) {
                    symbol.accept_all_children (this);
                }

                return false;
            }

            check_error_code (builder.start_element (type));
            check_error_code (builder.write_attribute ("id", symbol.get_full_name ()));
            check_error_code (builder.write_attribute ("name", symbol.name));

            check_error_code (builder.write_attribute ("deprecated", symbol.is_deprecated.to_string ()));
            check_error_code (builder.write_attribute ("internal", symbol.is_internal.to_string ()));
            check_error_code (builder.write_attribute ("private", symbol.is_private.to_string ()));
            check_error_code (builder.write_attribute ("protected", symbol.is_protected.to_string ()));
            check_error_code (builder.write_attribute ("public", symbol.is_public.to_string ()));

            return true;
        }

        private void write_attribute_list_element (Gee.Collection<Valadoc.Api.Attribute> attributes) {
            if (attributes.is_empty) {
                return;
            }

            check_error_code (builder.start_element ("attributes"));

            foreach (Valadoc.Api.Attribute attribute in attributes) {
                check_error_code (builder.write_element ("attribute", attribute.name));
            }

            check_error_code (builder.end_element ());
        }

        private void write_parent_list_element (Valadoc.Api.TypeReference? base_type, Gee.Collection<Valadoc.Api.TypeReference>? parent_interfaces = null) {
            if (base_type != null || (parent_interfaces != null && !parent_interfaces.is_empty)) {
                check_error_code (builder.start_element ("parents"));

                if (base_type != null) {
                    check_error_code (builder.write_element ("base_type", ((Valadoc.Api.Node)base_type.data_type).get_full_name ()));
                }

                if (parent_interfaces != null) {
                    foreach (Valadoc.Api.TypeReference parent_interface in parent_interfaces) {
                        check_error_code (builder.write_element ("parent_interface", ((Valadoc.Api.Node)parent_interface.data_type).get_full_name ()));
                    }
                }

                check_error_code (builder.end_element ());
            }
        }

        private void end_node_element (Valadoc.Api.Symbol symbol, bool is_container = false) {
            if (is_container) {
                check_error_code (builder.start_element ("members"));

                symbol.accept_all_children (this);

                check_error_code (builder.end_element ());
            }

            check_error_code (builder.end_element ());
        }
    }

    public class JsonDoclet : Valadoc.Doclet, Valadoc.Api.Visitor {
        private static const string OUTPUT_DIR = "docs";
        private static const bool USE_COMPRESSION = false;

        private Valadoc.Settings settings;

        public void process (Valadoc.Settings settings, Valadoc.Api.Tree tree, Valadoc.ErrorReporter reporter) {
            this.settings = settings;

            DirUtils.create_with_parents (OUTPUT_DIR, 0755);

            tree.accept (this);
        }

        public override void visit_tree (Valadoc.Api.Tree tree) {
            tree.accept_children (this);
        }

        public override void visit_package (Valadoc.Api.Package package) {
            if (!package.is_browsable (settings)) {
                return;
            }

            Xml.TextWriter builder = new Xml.TextWriter.filename ("%s/%s.xml".printf (OUTPUT_DIR, package.name), USE_COMPRESSION);
            builder.set_indent (true);
            check_error_code (builder.write_comment ("%s.xml generated by vala-doc-gen, do not modify.".printf (package.name)));
            check_error_code (builder.start_document ("1.0", "utf-8"));

            check_error_code (builder.start_element ("package"));
            check_error_code (builder.write_attribute ("name", package.name));

            PackageVisitor package_visitor = new PackageVisitor (builder);

            package.accept_all_children (package_visitor);

            check_error_code (builder.end_element ());
            check_error_code (builder.end_document ());
        }
    }

    private void check_error_code (int error_code) {
        if (error_code < 0) {
            error ("Writing to xml file failed with error code %i", error_code);
        }
    }
}

public Type register_plugin (Valadoc.ModuleLoader loader) {
    return typeof (DocGen.JsonDoclet);
}