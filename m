Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242EA6ED35
	for <lists+kvm-ppc@lfdr.de>; Sat, 20 Jul 2019 03:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbfGTBjb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Jul 2019 21:39:31 -0400
Received: from ozlabs.ru ([107.173.13.209]:47902 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728662AbfGTBjb (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 19 Jul 2019 21:39:31 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jul 2019 21:39:30 EDT
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 506A6AE807F9;
        Fri, 19 Jul 2019 21:29:25 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel RFC 2/2] powerpc/pseries: Kexec style ibm,client-architecture-support support
Date:   Sat, 20 Jul 2019 11:29:19 +1000
Message-Id: <20190720012919.14417-3-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190720012919.14417-1-aik@ozlabs.ru>
References: <20190720012919.14417-1-aik@ozlabs.ru>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This checks the FDT for "/chosen/qemu,h_cas" and calls H_CAS when present.
The H_CAS hcall is implemented in QEMU for ages and currently returns
an FDT with a diff to the initial FDT which SLOF updates and returns to
the OS. For this patch to work, QEMU needs to provide the full tree
instead, so when QEMU is run with the "-machine pseries,bios=no",
it reads the existing FDT from the OS, updats it and writes back on top.

This changes prom_check_platform_support() not to call the client
interface's prom_getproplen() as the kexec-style boot does not provide
the client interface services.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kernel/prom_init.c | 12 ++++++----
 arch/powerpc/kernel/setup_64.c  | 41 +++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 514707ef6779..6d8e35cb3c57 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1261,7 +1261,7 @@ static void __init prom_parse_platform_support(u8 index, u8 val,
 	}
 }
 
-static void __init prom_check_platform_support(void)
+struct ibm_arch_vec __init *prom_check_platform_support(int prop_len)
 {
 	struct platform_support supported = {
 		.hash_mmu = false,
@@ -1269,8 +1269,6 @@ static void __init prom_check_platform_support(void)
 		.radix_gtse = false,
 		.xive = false
 	};
-	int prop_len = prom_getproplen(prom.chosen,
-				       "ibm,arch-vec-5-platform-support");
 
 	/*
 	 * First copy the architecture vec template
@@ -1319,7 +1317,12 @@ static void __init prom_check_platform_support(void)
 		prom_debug("Asking for XIVE\n");
 		ibm_architecture_vec.vec5.intarch = OV5_FEAT(OV5_XIVE_EXPLOIT);
 	}
+
+	ibm_architecture_vec.vec5.max_cpus = cpu_to_be32(NR_CPUS);
+
+	return &ibm_architecture_vec;
 }
+EXPORT_SYMBOL_GPL(prom_check_platform_support);
 
 static void __init prom_send_capabilities(void)
 {
@@ -1328,7 +1331,8 @@ static void __init prom_send_capabilities(void)
 	u32 cores;
 
 	/* Check ibm,arch-vec-5-platform-support and fixup vec5 if required */
-	prom_check_platform_support();
+	prom_check_platform_support(prom_getproplen(prom.chosen,
+				"ibm,arch-vec-5-platform-support"));
 
 	root = call_prom("open", 1, 1, ADDR("/"));
 	if (root != 0) {
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 44b4c432a273..6fa384278180 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -284,12 +284,53 @@ void __init record_spr_defaults(void)
  * device-tree is not accessible via normal means at this point.
  */
 
+/*
+ * The architecture vector has an array of PVR mask/value pairs,
+ * followed by # option vectors - 1, followed by the option vectors.
+ *
+ * See prom.h for the definition of the bits specified in the
+ * architecture vector.
+ */
+
+extern struct ibm_arch_vec __init *prom_check_platform_support(
+		int vec5_prop_len);
+
+int __init early_init_dt_scan_chosen_h_cas(unsigned long node,
+		const char *uname, int depth, void *data)
+{
+	int l;
+	const char *p;
+
+	if (depth != 1 || !data ||
+	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
+		return 0;
+	p = of_get_flat_dt_prop(node, "qemu,h_cas", &l);
+	if (p != NULL && l > 0)
+		*(bool *) data = be32_to_cpu(*(uint32_t *) p) != 0;
+
+	return 1;
+}
+
 void __init early_setup(unsigned long dt_ptr)
 {
 	static __initdata struct paca_struct boot_paca;
+	struct ibm_arch_vec *vec = prom_check_platform_support(0);
 
 	/* -------- printk is _NOT_ safe to use here ! ------- */
 
+	/* ibm,client-architecture-support support */
+#define KVMPPC_HCALL_BASE       0xf000
+#define KVMPPC_H_CAS            (KVMPPC_HCALL_BASE + 0x2)
+#define FDT_MAX_SIZE 0x100000
+	bool do_h_cas = false;
+
+	if (early_init_dt_verify(__va(dt_ptr))) {
+		of_scan_flat_dt(early_init_dt_scan_chosen_h_cas, &do_h_cas);
+		if (do_h_cas)
+			plpar_hcall_norets(KVMPPC_H_CAS, vec, dt_ptr,
+					FDT_MAX_SIZE);
+	}
+
 	/* Try new device tree based feature discovery ... */
 	if (!dt_cpu_ftrs_init(__va(dt_ptr)))
 		/* Otherwise use the old style CPU table */
-- 
2.17.1

