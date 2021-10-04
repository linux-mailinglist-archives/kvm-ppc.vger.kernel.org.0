Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6FC421223
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 16:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbhJDO7o (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 10:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbhJDO7o (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 10:59:44 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EE9C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 07:57:55 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so168770pjb.1
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 07:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y3UUZ0cNS5SteKRQt8YweO+7E1xDF2fYjVUngXFgFMs=;
        b=OqiGrt0DXmiitRYwusII8DFq+kzJDqQp/2inSwFfjH0xKTskhUi5YBPDIKHevmziFo
         R+MHb5PJAhX1TONIYRepzHIeQ8Mpu6v4oruiNy9ZQzwQeFKTL6PokKv39SJ49tzQNHFv
         mHd5TUNffimvIpIXwJppAswfzceMF87ldMKAkXq4OMSzGX3cPhAaJ8zWi0VmywPTbWTA
         jzK7QkZqPoNXTl7fS/j0asf+GIIkgWSkLFHyzHbt1/1a3eSwmBqAnVPCvi41Byoz4ZWw
         BDQEU7Ca+6nC0CT8DKFnpI0JcyBw/p/1WUtZH8SgfmfFKJKHwx2nicdIgS/qDKoPLIxd
         a7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y3UUZ0cNS5SteKRQt8YweO+7E1xDF2fYjVUngXFgFMs=;
        b=BCxI26JpN3Im/jwCfP/pFviwmoNH6ATIUcS1kDai01IPjIR7zlgcZk2RjC1b8ozyk9
         499xTfODCxYHs3O3A3rQuOhAohU5ApcDmIU1uhQrlxUdrp4gxf5JetMTKDf0tBr9U5GQ
         i2Cu2zHrFLiSJArXAuQ6lUwVRHUT1j1EcEKwfqdRYiBCQl7oYh1T+8lWZVWb1Dx4iHON
         ULNbtLAmNHr381pEMwWRlEUhqwOPPK9hruL+IhyjF7otOODiCQltGcM19PBO2dMYsnDX
         guEes/9xOZ2dISoh2Cfx+0nq+4eZaPhWp/RtOJIqP//d7H7qNnpWvH2pvE6zHEzWBwQY
         sZQw==
X-Gm-Message-State: AOAM531HJc+o+CwlH32OsCNympAlxvuNK65a6fjXclrebG31afKn1SVQ
        Z0zP2ol1CjKG0AGfbMrG3w5YU3VcxZE=
X-Google-Smtp-Source: ABdhPJy6VdjXJ3xNwEf+bMNVUW6gf62/TkzUvDHjF9mPJTiL5ZB1lXsaL4xmtb4HUhzQFbi8cCztfQ==
X-Received: by 2002:a17:90b:4016:: with SMTP id ie22mr17389044pjb.29.1633359474755;
        Mon, 04 Oct 2021 07:57:54 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 127sm15052299pfw.10.2021.10.04.07.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 07:57:54 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH] KVM: PPC: Book3S HV: H_ENTER filter out reserved HPTE[B] value
Date:   Tue,  5 Oct 2021 00:57:49 +1000
Message-Id: <20211004145749.1331331-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The HPTE B field is a 2-bit field with values 0b10 and 0b11 reserved.
This field is also taken from the HPTE and used when KVM executes
TLBIEs to set the B field of those instructions.

Disallow the guest setting B to a reserved value with H_ENTER by
rejecting it. This is the same approach already taken for rejecting
reserved (unsupported) LLP values. This prevents the guest from being
able to induce the host to execute TLBIE with reserved values, which
is not known to be a problem with current processors but in theory it
could prevent the TLBIE from working correctly in a future processor.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s_64.h | 4 ++++
 arch/powerpc/kvm/book3s_hv_rm_mmu.c      | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 19b6942c6969..fff391b9b97b 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -378,6 +378,10 @@ static inline unsigned long compute_tlbie_rb(unsigned long v, unsigned long r,
 		rb |= 1;		/* L field */
 		rb |= r & 0xff000 & ((1ul << a_pgshift) - 1); /* LP field */
 	}
+	/*
+	 * This sets both bits of the B field in the PTE. 0b1x values are
+	 * reserved, but those will have been filtered by kvmppc_do_h_enter.
+	 */
 	rb |= (v >> HPTE_V_SSIZE_SHIFT) << 8;	/* B field */
 	return rb;
 }
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 632b2545072b..2c1f3c6e72d1 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -207,6 +207,15 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
 
 	if (kvm_is_radix(kvm))
 		return H_FUNCTION;
+	/*
+	 * The HPTE gets used by compute_tlbie_rb() to set TLBIE bits, so
+	 * these functions should work together -- must ensure a guest can not
+	 * cause problems with the TLBIE that KVM executes.
+	 */
+	if ((pteh >> HPTE_V_SSIZE_SHIFT) & 0x2) {
+		/* B=0b1x is a reserved value, disallow it. */
+		return H_PARAMETER;
+	}
 	psize = kvmppc_actual_pgsz(pteh, ptel);
 	if (!psize)
 		return H_PARAMETER;
-- 
2.23.0

