resource "azurerm_public_ip" "lb_public_ip" {
  name                = "7472_lb-pip"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "lb7472"

  tags = var.tags
}

resource "azurerm_lb" "lb_7472" {
  name                = "7472-lb"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEnd"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name                = "7472_bepool"
  #resource_group_name = var.rg_name      # ---> finding error 
  loadbalancer_id     = azurerm_lb.lb_7472.id
}

resource "azurerm_lb_probe" "http_probe" {
  name                = "http-probe"
  #resource_group_name = var.rg_name     # ----> finding error
  loadbalancer_id     = azurerm_lb.lb_7472.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "http_lb_rule" {
  name                           = "http-rule"
  #resource_group_name            = var.rg_name      # ----> finding error
  loadbalancer_id                = azurerm_lb.lb_7472.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.http_probe.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_backend_assoc" {
  for_each                = { for idx, id in var.vm_nics : idx => id }
  network_interface_id    = each.value
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}
