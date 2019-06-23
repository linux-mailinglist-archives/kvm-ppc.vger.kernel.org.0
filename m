Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 219D54FB23
	for <lists+kvm-ppc@lfdr.de>; Sun, 23 Jun 2019 12:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfFWKme (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 23 Jun 2019 06:42:34 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34431 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfFWKme (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 23 Jun 2019 06:42:34 -0400
Received: by mail-pg1-f195.google.com with SMTP id p10so5551019pgn.1
        for <kvm-ppc@vger.kernel.org>; Sun, 23 Jun 2019 03:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=unNl4TIULNSGXZXwmsz7laOJjV5XAQkpofGuTVj9KnI=;
        b=pwsT008927poPGhNOwLrTYxg6Mm2+0f1g9gdupfrSlp0F4Dc4KFDwADcu19Mp7a7Qr
         Ik0K1l8N3HZuGsDvwxsUIcsBhi2bYbNu29n8ZHxtn4kwrMiohffjx8ZHjujCEFdc5c/S
         fJau2DhSyiohHm7Z/ZEKljJO/GtMz0aXY8pS0bvljdJ5DZBxaFuKpDTWCK3gg+y6FtQa
         otc5mHKZn+f7tckZ9N/h5Yynm/VKQjrhyfS6iY5a4qzOG5UCoytWd8G4fcDOGs1KMLUc
         28hoFyfYAHQYkX6QGD3CnDtBEet1Tw05SdMr04LMZ99MCvVgGnoevXo6QMnVnmNQdxKk
         91hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=unNl4TIULNSGXZXwmsz7laOJjV5XAQkpofGuTVj9KnI=;
        b=B25M9fJh29DTaqf1BgPIMXTd6Dkb7YWo6Se26M2pmyzAht3XkH5PxixGQIFqqjPmYT
         L2hVTI5TO6CRQS4yR3Ef3DGQyoh73eGi4eym5+Z+10SWijSv8aEIopAepprmhSMtKQYt
         J99qX3cqfHM6WpfwYLfIDR99rgl+Edu9c1Am8PQtN1gkSchbpufrF4Vg1jBfo8J1UPnu
         qreS6xyW3/k1P7TtuX5Td8sORDDyFx6yf/PbHufPXdp1oEjNmgsqR/wtb84sSWnRsP7v
         keA6NqR/RgjaxIVCSrV8d46UEqbsqBcKCYdRy/OMoey8PfsokMlLh8f4m7yCEN8m2Myt
         oAeg==
X-Gm-Message-State: APjAAAWBM4oQVT7h+ciAW5iUeQhJMXYMdpA0G2xvvzx/iXGknJjGMdil
        kGZicEusGrTIgvReijTLPxQ=
X-Google-Smtp-Source: APXvYqxIAzEtHdWzE4+9l+W+rtoJ5ki/VCu1i2Ip7JQP7mu9qkGb62wiIwv1EZW/9RstTG4bTkayhg==
X-Received: by 2002:a17:90a:7148:: with SMTP id g8mr18234825pjs.51.1561286553264;
        Sun, 23 Jun 2019 03:42:33 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([1.129.156.40])
        by smtp.gmail.com with ESMTPSA id w7sm5034824pfb.117.2019.06.23.03.42.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 23 Jun 2019 03:42:32 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Subject: [PATCH 1/2] powerpc/64s: Rename PPC_INVALIDATE_ERAT to PPC_ARCH_300_INVALIDATE_ERAT
Date:   Sun, 23 Jun 2019 20:41:51 +1000
Message-Id: <20190623104152.13173-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This makes it clear to the caller that it can only be used on POWER9
and later CPUs.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
I think I added a bug in machine checks at one point that I might have
been able to avoid with this name :)

 arch/powerpc/include/asm/ppc-opcode.h  | 2 +-
 arch/powerpc/kernel/mce_power.c        | 3 +--
 arch/powerpc/kvm/book3s_hv_builtin.c   | 2 +-
 arch/powerpc/mm/book3s64/hash_native.c | 2 +-
 arch/powerpc/mm/book3s64/radix_tlb.c   | 8 ++++----
 arch/powerpc/platforms/powernv/idle.c  | 2 +-
 6 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index 2291daf39cd1..156102828a3b 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -588,7 +588,7 @@
 
 #define PPC_SLBIA(IH)	stringify_in_c(.long PPC_INST_SLBIA | \
 				       ((IH & 0x7) << 21))
-#define PPC_INVALIDATE_ERAT	PPC_SLBIA(7)
+#define PPC_ARCH_300_INVALIDATE_ERAT	PPC_SLBIA(7)
 
 #define VCMPEQUD_RC(vrt, vra, vrb)	stringify_in_c(.long PPC_INST_VCMPEQUD | \
 			      ___PPC_RT(vrt) | ___PPC_RA(vra) | \
diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_power.c
index e39536aad30d..91e20773d8c3 100644
--- a/arch/powerpc/kernel/mce_power.c
+++ b/arch/powerpc/kernel/mce_power.c
@@ -82,8 +82,7 @@ static void flush_erat(void)
 		return;
 	}
 #endif
-	/* PPC_INVALIDATE_ERAT can only be used on ISA v3 and newer */
-	asm volatile(PPC_INVALIDATE_ERAT : : :"memory");
+	asm volatile(PPC_ARCH_300_INVALIDATE_ERAT : : :"memory");
 }
 
 #define MCE_FLUSH_SLB 1
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index cb05ccc8bc6a..960154262665 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -830,7 +830,7 @@ static void flush_guest_tlb(struct kvm *kvm)
 		}
 	}
 	asm volatile("ptesync": : :"memory");
-	asm volatile(PPC_INVALIDATE_ERAT : : :"memory");
+	asm volatile(PPC_ARCH_300_INVALIDATE_ERAT : : :"memory");
 }
 
 void kvmppc_check_need_tlb_flush(struct kvm *kvm, int pcpu,
diff --git a/arch/powerpc/mm/book3s64/hash_native.c b/arch/powerpc/mm/book3s64/hash_native.c
index 30d62ffe3310..55a1716926b1 100644
--- a/arch/powerpc/mm/book3s64/hash_native.c
+++ b/arch/powerpc/mm/book3s64/hash_native.c
@@ -112,7 +112,7 @@ static void tlbiel_all_isa300(unsigned int num_sets, unsigned int is)
 
 	asm volatile("ptesync": : :"memory");
 
-	asm volatile(PPC_INVALIDATE_ERAT "; isync" : : :"memory");
+	asm volatile(PPC_ARCH_300_INVALIDATE_ERAT "; isync" : : :"memory");
 }
 
 void hash__tlbiel_all(unsigned int action)
diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index bb9835681315..17f33b6645f9 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -83,7 +83,7 @@ void radix__tlbiel_all(unsigned int action)
 	else
 		WARN(1, "%s called on pre-POWER9 CPU\n", __func__);
 
-	asm volatile(PPC_INVALIDATE_ERAT "; isync" : : :"memory");
+	asm volatile(PPC_ARCH_300_INVALIDATE_ERAT "; isync" : : :"memory");
 }
 
 static __always_inline void __tlbiel_pid(unsigned long pid, int set,
@@ -258,7 +258,7 @@ static inline void _tlbiel_pid(unsigned long pid, unsigned long ric)
 		__tlbiel_pid(pid, set, RIC_FLUSH_TLB);
 
 	asm volatile("ptesync": : :"memory");
-	asm volatile(PPC_INVALIDATE_ERAT "; isync" : : :"memory");
+	asm volatile(PPC_ARCH_300_INVALIDATE_ERAT "; isync" : : :"memory");
 }
 
 static inline void _tlbie_pid(unsigned long pid, unsigned long ric)
@@ -310,7 +310,7 @@ static inline void _tlbiel_lpid(unsigned long lpid, unsigned long ric)
 		__tlbiel_lpid(lpid, set, RIC_FLUSH_TLB);
 
 	asm volatile("ptesync": : :"memory");
-	asm volatile(PPC_INVALIDATE_ERAT "; isync" : : :"memory");
+	asm volatile(PPC_ARCH_300_INVALIDATE_ERAT "; isync" : : :"memory");
 }
 
 static inline void _tlbie_lpid(unsigned long lpid, unsigned long ric)
@@ -362,7 +362,7 @@ static inline void _tlbiel_lpid_guest(unsigned long lpid, unsigned long ric)
 		__tlbiel_lpid_guest(lpid, set, RIC_FLUSH_TLB);
 
 	asm volatile("ptesync": : :"memory");
-	asm volatile(PPC_INVALIDATE_ERAT : : :"memory");
+	asm volatile(PPC_ARCH_300_INVALIDATE_ERAT : : :"memory");
 }
 
 
diff --git a/arch/powerpc/platforms/powernv/idle.c b/arch/powerpc/platforms/powernv/idle.c
index 2f4479b94ac3..fea2fab6d915 100644
--- a/arch/powerpc/platforms/powernv/idle.c
+++ b/arch/powerpc/platforms/powernv/idle.c
@@ -716,7 +716,7 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
 		 * to reload MMCR0 (see mmcr0 comment above).
 		 */
 		if (!cpu_has_feature(CPU_FTR_POWER9_DD2_1)) {
-			asm volatile(PPC_INVALIDATE_ERAT);
+			asm volatile(PPC_ARCH_300_INVALIDATE_ERAT);
 			mtspr(SPRN_MMCR0, mmcr0);
 		}
 
-- 
2.20.1

