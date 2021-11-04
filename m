Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56645444C22
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Nov 2021 01:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhKDA3y (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 3 Nov 2021 20:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbhKDA2m (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 3 Nov 2021 20:28:42 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE26C061205
        for <kvm-ppc@vger.kernel.org>; Wed,  3 Nov 2021 17:26:05 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id i25-20020a631319000000b002cce0a43e94so2443820pgl.0
        for <kvm-ppc@vger.kernel.org>; Wed, 03 Nov 2021 17:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=E63+zcqes7aObPmDEJrvowSyb7WASC2+JFrjiGuoOMk=;
        b=G1EofX3RvsgDocbJ2WdlZIxLPrRqCOY3yk9dCpHXn3BrotBTcINoCOIdoZtnGuqNkz
         XjduJywdhEpzM76x4KoUTmOMqDWGTwqBcR9WlCLJ/Ixo7OZNiFzolIn6uGeuv97Lynv7
         ddl94QsCyWYRP1cDpWTxGlOfLjkpa9JMyPhL71/QGQqzOCEiWBc8/ntYod6VDaOBqRIS
         X353qmmShX/kJORUwjw2weuKuQNgd6XS84Jwff3SPGUNlABXgf8tKjegkYwWGGN3YZ/S
         LGQAetSmsnJyG5LH2Wdt7/WsV81v8KEKNpq61Fts5PSRMZc9eqQNsC0W+vLYcBCTaqSh
         tOqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=E63+zcqes7aObPmDEJrvowSyb7WASC2+JFrjiGuoOMk=;
        b=325Znu0W3LyiC22GsggSn96L90tQYIWIi1aycb8k/iowqmpHCGWB05DEyE13Ggv5eg
         UVzishMOJQcuCHwFGD+p7DqgkrfiTyQWKbxOj1Cf4aJLG3LIsCnJ7lqfnJlBrcXMZduR
         +MdHY3joGx6ITi7N7LbDZ4nNtEnOcXJnYI3CisHxeRX4meU/eVx8mjIjWlQUfWDKH7uJ
         YNt8y9poVOPsnA3wrr4D2XnzH+0NJifDocbqL0Qv7dSFa7QntFbkIKcmpZbKzuQXQrOh
         +8N2oNdwus5E6MXU8OmiknBWEGOt14amXe9XBBdCwnJaG0KwG4dJ+IU31YjtEYZDU5DG
         6KJQ==
X-Gm-Message-State: AOAM533WMqDczTTwFTw55l/51q2j7rqtohE7T9FYKiuFcx+TvCdH3pou
        9VIsvRECLMmR66rqlYz9SGHVQ4iIw6A=
X-Google-Smtp-Source: ABdhPJyxb/nQ01mzKYX4m8bfp03Ule2nAlwfJSHz9a05yqoefRBI+SnT6XPXcdLf6g/xUstLGwYZnueYC+Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:1b8e:0:b0:44c:9318:f6e1 with SMTP id
 b136-20020a621b8e000000b0044c9318f6e1mr48578653pfb.84.1635985564791; Wed, 03
 Nov 2021 17:26:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:05 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-5-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 04/30] KVM: Open code kvm_delete_memslot() into its only caller
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Fold kvm_delete_memslot() into __kvm_set_memory_region() to free up the
"kvm_delete_memslot()" name for use in a future helper.  The delete logic
isn't so complex/long that it truly needs a helper, and it will be
simplified a wee bit further in upcoming commits.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 264c4b16520b..6171ddb3e31c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1653,29 +1653,6 @@ static int kvm_set_memslot(struct kvm *kvm,
 	return r;
 }
 
-static int kvm_delete_memslot(struct kvm *kvm,
-			      const struct kvm_userspace_memory_region *mem,
-			      struct kvm_memory_slot *old, int as_id)
-{
-	struct kvm_memory_slot new;
-
-	if (!old->npages)
-		return -EINVAL;
-
-	if (WARN_ON_ONCE(kvm->nr_memslot_pages < old->npages))
-		return -EIO;
-
-	memset(&new, 0, sizeof(new));
-	new.id = old->id;
-	/*
-	 * This is only for debugging purpose; it should never be referenced
-	 * for a removed memslot.
-	 */
-	new.as_id = as_id;
-
-	return kvm_set_memslot(kvm, mem, &new, as_id, KVM_MR_DELETE);
-}
-
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -1732,8 +1709,23 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		old.id = id;
 	}
 
-	if (!mem->memory_size)
-		return kvm_delete_memslot(kvm, mem, &old, as_id);
+	if (!mem->memory_size) {
+		if (!old.npages)
+			return -EINVAL;
+
+		if (WARN_ON_ONCE(kvm->nr_memslot_pages < old.npages))
+			return -EIO;
+
+		memset(&new, 0, sizeof(new));
+		new.id = id;
+		/*
+		 * This is only for debugging purpose; it should never be
+		 * referenced for a removed memslot.
+		 */
+		new.as_id = as_id;
+
+		return kvm_set_memslot(kvm, mem, &new, as_id, KVM_MR_DELETE);
+	}
 
 	new.as_id = as_id;
 	new.id = id;
-- 
2.33.1.1089.g2158813163f-goog

