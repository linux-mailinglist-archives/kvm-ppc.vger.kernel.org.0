Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA951CC6FA
	for <lists+kvm-ppc@lfdr.de>; Sun, 10 May 2020 07:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgEJFSo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 10 May 2020 01:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgEJFSo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 10 May 2020 01:18:44 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A14C061A0E
        for <kvm-ppc@vger.kernel.org>; Sat,  9 May 2020 22:18:44 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id v4so4259105qte.3
        for <kvm-ppc@vger.kernel.org>; Sat, 09 May 2020 22:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/lcyVkFvW6Q2XtFR89qoX9NO7slQxZQ5eBaDk/SNENo=;
        b=rmYgUAkvZpyFKZcqeGRIyvvBHeg1jJroQIIofbBodDDku0mcvJo/BQqa8SHRnYFJaI
         iqRx162shMpOm75JtRUCjAztD6+DXrguzJeHeiY0iDxuUsed8YT2MBAQ/dfri9YyfUp8
         6bnqunS5v3p+wvBbGonBj8t9Z8x3KvRuUgMi8iC2VSOtO5C6jXY36T5uOUnPdGbG/1ZL
         1X6XVaJ89ce89/aFmh9J7wCcKb+tPmp5rcuzf/s8MkrvYGJOaHuBeUmI9Q8OCZRdbTy4
         Xmc6apEkT+68fWOBPlI1a52fi1BLx2dAZ1yz5z5Lo8NpgrnK32By/KQX+EBLeJ1rx1Va
         RFjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/lcyVkFvW6Q2XtFR89qoX9NO7slQxZQ5eBaDk/SNENo=;
        b=NXD6FQsGlQU9NRoQEhWEfApdD0nr8jWaDmVmuwVZpbvZSg8k86kzko0p/wTeTY56Gb
         YmGHtJL8zAFdpHJ7PaKkZNFgHYIZg4SnLnA51/Md2dVyd8KA8sMG8oS+d6RfSSJ+vSCS
         yetbqgBgAfGvcvjEWhChm/W2mKWnMAKIM80qPnCn4qYHVdmLSWs/XyR7JJlfkvgocEj0
         njy8nv5ORGqssytS9I0kYcorMwFptLUJXnf5sgBSGUnjQ/JH5go3VB7NZhq9LMPHWlwg
         N8fRvP7OWkbmajDOgK2dOEOdmVh+5sGUuQsDvgcQU88UcXfKplBcDcBib/NtqCz4zIQq
         J08g==
X-Gm-Message-State: AGi0PuaYk3nUKOvhiQ6mjFNYAFhFoJrMJ3mYQ/RSSlGVWHhhOzchdmtN
        1mho0TXBXtORRcglzLyL+3CRnQ==
X-Google-Smtp-Source: APiQypK5nCri8dvQyy2Srb2XSRl+X2gaOjzChXlYZVh4WI3iYi/fXLwXzIeA9OlCUfW0kVaa22XLVw==
X-Received: by 2002:ac8:4987:: with SMTP id f7mr10426013qtq.160.1589087923115;
        Sat, 09 May 2020 22:18:43 -0700 (PDT)
Received: from ovpn-112-80.rdu2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id p31sm6067732qtf.11.2020.05.09.22.18.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 May 2020 22:18:42 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     mpe@ellerman.id.au
Cc:     benh@kernel.crashing.org, paulus@samba.org, aik@ozlabs.ru,
        paulmck@kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>
Subject: [PATCH] powerpc/kvm/book3s64/vio: fix some RCU-list locks
Date:   Sun, 10 May 2020 01:18:34 -0400
Message-Id: <20200510051834.2011-1-cai@lca.pw>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

It is unsafe to traverse kvm->arch.spapr_tce_tables and
stt->iommu_tables without the RCU read lock held. Also, add
cond_resched_rcu() in places with the RCU read lock held that could take
a while to finish.

 arch/powerpc/kvm/book3s_64_vio.c:76 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 no locks held by qemu-kvm/4265.

 stack backtrace:
 CPU: 96 PID: 4265 Comm: qemu-kvm Not tainted 5.7.0-rc4-next-20200508+ #2
 Call Trace:
 [c000201a8690f720] [c000000000715948] dump_stack+0xfc/0x174 (unreliable)
 [c000201a8690f770] [c0000000001d9470] lockdep_rcu_suspicious+0x140/0x164
 [c000201a8690f7f0] [c008000010b9fb48] kvm_spapr_tce_release_iommu_group+0x1f0/0x220 [kvm]
 [c000201a8690f870] [c008000010b8462c] kvm_spapr_tce_release_vfio_group+0x54/0xb0 [kvm]
 [c000201a8690f8a0] [c008000010b84710] kvm_vfio_destroy+0x88/0x140 [kvm]
 [c000201a8690f8f0] [c008000010b7d488] kvm_put_kvm+0x370/0x600 [kvm]
 [c000201a8690f990] [c008000010b7e3c0] kvm_vm_release+0x38/0x60 [kvm]
 [c000201a8690f9c0] [c0000000005223f4] __fput+0x124/0x330
 [c000201a8690fa20] [c000000000151cd8] task_work_run+0xb8/0x130
 [c000201a8690fa70] [c0000000001197e8] do_exit+0x4e8/0xfa0
 [c000201a8690fb70] [c00000000011a374] do_group_exit+0x64/0xd0
 [c000201a8690fbb0] [c000000000132c90] get_signal+0x1f0/0x1200
 [c000201a8690fcc0] [c000000000020690] do_notify_resume+0x130/0x3c0
 [c000201a8690fda0] [c000000000038d64] syscall_exit_prepare+0x1a4/0x280
 [c000201a8690fe20] [c00000000000c8f8] system_call_common+0xf8/0x278

 ====
 arch/powerpc/kvm/book3s_64_vio.c:368 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 2 locks held by qemu-kvm/4264:
  #0: c000201ae2d000d8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0xdc/0x950 [kvm]
  #1: c000200c9ed0c468 (&kvm->srcu){....}-{0:0}, at: kvmppc_h_put_tce+0x88/0x340 [kvm]

 ====
 arch/powerpc/kvm/book3s_64_vio.c:108 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by qemu-kvm/4257:
  #0: c000200b1b363a40 (&kv->lock){+.+.}-{3:3}, at: kvm_vfio_set_attr+0x598/0x6c0 [kvm]

 ====
 arch/powerpc/kvm/book3s_64_vio.c:146 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by qemu-kvm/4257:
  #0: c000200b1b363a40 (&kv->lock){+.+.}-{3:3}, at: kvm_vfio_set_attr+0x598/0x6c0 [kvm]

Signed-off-by: Qian Cai <cai@lca.pw>
---
 arch/powerpc/kvm/book3s_64_vio.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 50555ad1db93..4f5016bab723 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -73,6 +73,7 @@ extern void kvm_spapr_tce_release_iommu_group(struct kvm *kvm,
 	struct kvmppc_spapr_tce_iommu_table *stit, *tmp;
 	struct iommu_table_group *table_group = NULL;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(stt, &kvm->arch.spapr_tce_tables, list) {
 
 		table_group = iommu_group_get_iommudata(grp);
@@ -87,7 +88,9 @@ extern void kvm_spapr_tce_release_iommu_group(struct kvm *kvm,
 				kref_put(&stit->kref, kvm_spapr_tce_liobn_put);
 			}
 		}
+		cond_resched_rcu();
 	}
+	rcu_read_unlock();
 }
 
 extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
@@ -105,12 +108,14 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 	if (!f.file)
 		return -EBADF;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(stt, &kvm->arch.spapr_tce_tables, list) {
 		if (stt == f.file->private_data) {
 			found = true;
 			break;
 		}
 	}
+	rcu_read_unlock();
 
 	fdput(f);
 
@@ -143,6 +148,7 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 	if (!tbl)
 		return -EINVAL;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(stit, &stt->iommu_tables, next) {
 		if (tbl != stit->tbl)
 			continue;
@@ -150,14 +156,17 @@ extern long kvm_spapr_tce_attach_iommu_group(struct kvm *kvm, int tablefd,
 		if (!kref_get_unless_zero(&stit->kref)) {
 			/* stit is being destroyed */
 			iommu_tce_table_put(tbl);
+			rcu_read_unlock();
 			return -ENOTTY;
 		}
 		/*
 		 * The table is already known to this KVM, we just increased
 		 * its KVM reference counter and can return.
 		 */
+		rcu_read_unlock();
 		return 0;
 	}
+	rcu_read_unlock();
 
 	stit = kzalloc(sizeof(*stit), GFP_KERNEL);
 	if (!stit) {
@@ -365,18 +374,20 @@ static long kvmppc_tce_validate(struct kvmppc_spapr_tce_table *stt,
 	if (kvmppc_tce_to_ua(stt->kvm, tce, &ua))
 		return H_TOO_HARD;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(stit, &stt->iommu_tables, next) {
 		unsigned long hpa = 0;
 		struct mm_iommu_table_group_mem_t *mem;
 		long shift = stit->tbl->it_page_shift;
 
 		mem = mm_iommu_lookup(stt->kvm->mm, ua, 1ULL << shift);
-		if (!mem)
-			return H_TOO_HARD;
-
-		if (mm_iommu_ua_to_hpa(mem, ua, shift, &hpa))
+		if (!mem || mm_iommu_ua_to_hpa(mem, ua, shift, &hpa)) {
+			rcu_read_unlock();
 			return H_TOO_HARD;
+		}
+		cond_resched_rcu();
 	}
+	rcu_read_unlock();
 
 	return H_SUCCESS;
 }
-- 
2.21.0 (Apple Git-122.2)

