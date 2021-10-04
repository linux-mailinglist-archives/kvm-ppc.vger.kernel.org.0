Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8749642134A
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbhJDQDF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbhJDQDB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:01 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABF9C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:12 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q23so14898112pfs.9
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5pcRvtdslqLe3269KSh6pekuy65GoxrcpKwBn7DAUtU=;
        b=mgMJaoHkilZlL1u7SJCBpMIDKwSglv7DrTVjNzZ0xMLUxtoN9IeiviAfkQNGQ3/Jkm
         LkUYA89+rjLF31E4UnH6SV0XBubItXuG5oB9MDuwhFEG2aRNuCw1jupWHsmV9n9N+zJ+
         AOcztA6hGqasVBtN/aDviQbGQNsFglTy+LXN2+BoK99ut1C1Gmx3rCxLnxwnf0Dw4IVP
         59rkyeQOEr+GH5O2Va2AaV+jEstiIPVz4aipnUDmUYs6I65td30rGBRB0ASwvSGv7KTk
         FREzPtoyYN7kbGDBblzBAM46mMmz2wyLuNZYlqrCdiCpFDCAgIcdKCYRjKhc4WSOKS3j
         4Izg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5pcRvtdslqLe3269KSh6pekuy65GoxrcpKwBn7DAUtU=;
        b=jkGA6xo8a4vN+qti1CcDGgi/fio3kpAdSPIfaBGsrrM2Ejk8ac8cz/J1WhuXA9fPx2
         elnQEAR37p5E0gT+3ABEZV8vqJXaEOn2fz6v4MdImkSYJ39/jC2XrnxHXOubisTaSuPv
         tbA1pwvC6ptQklll5HuhrrtV+HHl2yJQrS9epiIdSC5Bc5FjC9SP3CpzmpwH3l6sCWrd
         mrpaZRnuNzEhLsH6KZyP6SMOuC8Dfh97EQQTqZcAHkgqoJk8viFtIfZspR+bQ52b4y6i
         JloutxsVUPeyTAkxAUbMIeWAI6E5NdiC1RvLCSvJpkDvbRansEduSfiWcCodypH+2jqI
         BDMQ==
X-Gm-Message-State: AOAM531FN+3RX3XPGkRIIVKx7Ylw/C40JzR0QYrrzPcCdJORQb9HUAKw
        GB4n5kBb1v9W33ifWKZH2fA8FCtZs3Q=
X-Google-Smtp-Source: ABdhPJxbHxvVGtRL43v+pJW6MIX61tzQ8nXeti2cnql5N0HFZJE138rMYH782+IzzvUCqRmucJNo/A==
X-Received: by 2002:a05:6a00:cc9:b0:44c:2305:50de with SMTP id b9-20020a056a000cc900b0044c230550demr15931064pfv.79.1633363271367;
        Mon, 04 Oct 2021 09:01:11 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:11 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 04/52] KVM: PPC: Book3S HV P9: Use host timer accounting to avoid decrementer read
Date:   Tue,  5 Oct 2021 02:00:01 +1000
Message-Id: <20211004160049.1338837-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

There is no need to save away the host DEC value, as it is derived
from the host timer subsystem which maintains the next timer time,
so it can be restored from there.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h |  5 +++++
 arch/powerpc/kernel/time.c      |  1 +
 arch/powerpc/kvm/book3s_hv.c    | 14 +++++++-------
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 8c2c3dd4ddba..fd09b4797fd7 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -111,6 +111,11 @@ static inline unsigned long test_irq_work_pending(void)
 
 DECLARE_PER_CPU(u64, decrementers_next_tb);
 
+static inline u64 timer_get_next_tb(void)
+{
+	return __this_cpu_read(decrementers_next_tb);
+}
+
 /* Convert timebase ticks to nanoseconds */
 unsigned long long tb_to_ns(unsigned long long tb_ticks);
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 934d8ae66cc6..e84a087223ce 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -107,6 +107,7 @@ struct clock_event_device decrementer_clockevent = {
 EXPORT_SYMBOL(decrementer_clockevent);
 
 DEFINE_PER_CPU(u64, decrementers_next_tb);
+EXPORT_SYMBOL_GPL(decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
 
 #define XSEC_PER_SEC (1024*1024)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6a07a79f07d8..30d400bf161b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3860,18 +3860,17 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	struct p9_host_os_sprs host_os_sprs;
 	s64 dec;
-	u64 tb;
+	u64 tb, next_timer;
 	int trap, save_pmu;
 
 	WARN_ON_ONCE(vcpu->arch.ceded);
 
-	dec = mfspr(SPRN_DEC);
 	tb = mftb();
-	if (dec < 0)
+	next_timer = timer_get_next_tb();
+	if (tb >= next_timer)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
-	local_paca->kvm_hstate.dec_expires = dec + tb;
-	if (local_paca->kvm_hstate.dec_expires < time_limit)
-		time_limit = local_paca->kvm_hstate.dec_expires;
+	if (next_timer < time_limit)
+		time_limit = next_timer;
 
 	save_p9_host_os_sprs(&host_os_sprs);
 
@@ -4050,7 +4049,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	set_dec(local_paca->kvm_hstate.dec_expires - mftb());
+	next_timer = timer_get_next_tb();
+	set_dec(next_timer - mftb());
 	/* We may have raced with new irq work */
 	if (test_irq_work_pending())
 		set_dec(1);
-- 
2.23.0

