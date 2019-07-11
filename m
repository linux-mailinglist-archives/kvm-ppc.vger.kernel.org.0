Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDD8660D8
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Jul 2019 22:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbfGKUpw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Jul 2019 16:45:52 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44775 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728628AbfGKUpw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Jul 2019 16:45:52 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so3482745pgl.11
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Jul 2019 13:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FAgMNOYOPvzfrhNLldHVb19fW7VpQgXrnLMhcZOOzzs=;
        b=BwhngOtO8Nu7zYAeNU/xva2uz2AnFZ9jfpv+3OHWnK+riarbVIlSWPdfB25P++KWpM
         QVxLEPUIHjMA+QqfkfkhctquS0azuY/r/ojtxpUWtUfoWtmq6qMLYBDzqHmuxtUJ30oy
         MTd0LwPXNYB62gu7TJfWJlr+m4tzWAaTOQACU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FAgMNOYOPvzfrhNLldHVb19fW7VpQgXrnLMhcZOOzzs=;
        b=RWNBJotb17yEdmDAtdINZyBnlF5ZCH27Hh3haSLHVPJdJfWb0lDFZrOscP5fvXSmU5
         DIdDy36gRERfPrF3gj0ZbMfj9CGDtP+3S098CLNpgL/fggM7mb7HpyCcfcE2Vp6bTLKz
         qKr2AqjZvObWhiRXEvDIN1Mg8s37B0vrxb9HO1GnyAbAtpNke1c3IjVkiapvpBM7P05K
         e1oo2jse1Ft7/NPTBgSl+wcBHwIK9fFUOT2brmo4uAukFr6iF99bgvz4djtg1hfWixvA
         6Y2mMWP6VpN8+SlBzV1NnWZJ2nhTZlZG/N0zwikdW0DFQ92NfWci5Ap/t+K3sQyb3r/K
         upmw==
X-Gm-Message-State: APjAAAX1qMjG47eaNZ5mKEVeeRprYpywzQLz66drNsBsE/n4InSkhPwL
        JMRro4bFs1ndffsQyJjj4Hk=
X-Google-Smtp-Source: APXvYqzwqFWG5FAS708qmjT7OvxwSnxErqOKN+3y3GLJgx3B9ybHEpj1LDsHWYbII1JJoa1at0PEqA==
X-Received: by 2002:a63:4d50:: with SMTP id n16mr6518323pgl.146.1562877951310;
        Thu, 11 Jul 2019 13:45:51 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id f19sm9047502pfk.180.2019.07.11.13.45.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 13:45:50 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, kvm-ppc@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, byungchul.park@lge.com,
        kernel-team@android.com
Subject: [PATCH] treewide: Rename  rcu_dereference_raw_notrace to _check
Date:   Thu, 11 Jul 2019 16:45:41 -0400
Message-Id: <20190711204541.28940-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The rcu_dereference_raw_notrace() API name is confusing.
It is equivalent to rcu_dereference_raw() except that it also does
sparse pointer checking.

There are only a few users of rcu_dereference_raw_notrace(). This
patches renames all of them to be rcu_dereference_raw_check with the
"check" indicating sparse checking.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

---
Previous discussion is here:
https://lore.kernel.org/linuxppc-dev/20190528200014.GV28207@linux.ibm.com/T/

 Documentation/RCU/Design/Requirements/Requirements.html | 2 +-
 arch/powerpc/include/asm/kvm_book3s_64.h                | 2 +-
 include/linux/rculist.h                                 | 4 ++--
 include/linux/rcupdate.h                                | 2 +-
 kernel/trace/ftrace_internal.h                          | 8 ++++----
 kernel/trace/trace.c                                    | 4 ++--
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/RCU/Design/Requirements/Requirements.html b/Documentation/RCU/Design/Requirements/Requirements.html
index f04c467e55c5..467251f7fef6 100644
--- a/Documentation/RCU/Design/Requirements/Requirements.html
+++ b/Documentation/RCU/Design/Requirements/Requirements.html
@@ -2514,7 +2514,7 @@ disabled across the entire RCU read-side critical section.
 <p>
 It is possible to use tracing on RCU code, but tracing itself
 uses RCU.
-For this reason, <tt>rcu_dereference_raw_notrace()</tt>
+For this reason, <tt>rcu_dereference_raw_check()</tt>
 is provided for use by tracing, which avoids the destructive
 recursion that could otherwise ensue.
 This API is also used by virtualization in some architectures,
diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 21b1ed5df888..53388a311967 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -546,7 +546,7 @@ static inline void note_hpte_modification(struct kvm *kvm,
  */
 static inline struct kvm_memslots *kvm_memslots_raw(struct kvm *kvm)
 {
-	return rcu_dereference_raw_notrace(kvm->memslots[0]);
+	return rcu_dereference_raw_check(kvm->memslots[0]);
 }
 
 extern void kvmppc_mmu_debugfs_init(struct kvm *kvm);
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e91ec9ddcd30..10aab1d2d471 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -642,10 +642,10 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
  * not do any RCU debugging or tracing.
  */
 #define hlist_for_each_entry_rcu_notrace(pos, head, member)			\
-	for (pos = hlist_entry_safe (rcu_dereference_raw_notrace(hlist_first_rcu(head)),\
+	for (pos = hlist_entry_safe (rcu_dereference_raw_check(hlist_first_rcu(head)),\
 			typeof(*(pos)), member);			\
 		pos;							\
-		pos = hlist_entry_safe(rcu_dereference_raw_notrace(hlist_next_rcu(\
+		pos = hlist_entry_safe(rcu_dereference_raw_check(hlist_next_rcu(\
 			&(pos)->member)), typeof(*(pos)), member))
 
 /**
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 0c9b92799abc..e5161e377ad4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -478,7 +478,7 @@ do {									      \
  * The no-tracing version of rcu_dereference_raw() must not call
  * rcu_read_lock_held().
  */
-#define rcu_dereference_raw_notrace(p) __rcu_dereference_check((p), 1, __rcu)
+#define rcu_dereference_raw_check(p) __rcu_dereference_check((p), 1, __rcu)
 
 /**
  * rcu_dereference_protected() - fetch RCU pointer when updates prevented
diff --git a/kernel/trace/ftrace_internal.h b/kernel/trace/ftrace_internal.h
index 0515a2096f90..0456e0a3dab1 100644
--- a/kernel/trace/ftrace_internal.h
+++ b/kernel/trace/ftrace_internal.h
@@ -6,22 +6,22 @@
 
 /*
  * Traverse the ftrace_global_list, invoking all entries.  The reason that we
- * can use rcu_dereference_raw_notrace() is that elements removed from this list
+ * can use rcu_dereference_raw_check() is that elements removed from this list
  * are simply leaked, so there is no need to interact with a grace-period
- * mechanism.  The rcu_dereference_raw_notrace() calls are needed to handle
+ * mechanism.  The rcu_dereference_raw_check() calls are needed to handle
  * concurrent insertions into the ftrace_global_list.
  *
  * Silly Alpha and silly pointer-speculation compiler optimizations!
  */
 #define do_for_each_ftrace_op(op, list)			\
-	op = rcu_dereference_raw_notrace(list);			\
+	op = rcu_dereference_raw_check(list);			\
 	do
 
 /*
  * Optimized for just a single item in the list (as that is the normal case).
  */
 #define while_for_each_ftrace_op(op)				\
-	while (likely(op = rcu_dereference_raw_notrace((op)->next)) &&	\
+	while (likely(op = rcu_dereference_raw_check((op)->next)) &&	\
 	       unlikely((op) != &ftrace_list_end))
 
 extern struct ftrace_ops __rcu *ftrace_ops_list;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2c92b3d9ea30..1d69110d9e5b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2642,10 +2642,10 @@ static void ftrace_exports(struct ring_buffer_event *event)
 
 	preempt_disable_notrace();
 
-	export = rcu_dereference_raw_notrace(ftrace_exports_list);
+	export = rcu_dereference_raw_check(ftrace_exports_list);
 	while (export) {
 		trace_process_export(export, event);
-		export = rcu_dereference_raw_notrace(export->next);
+		export = rcu_dereference_raw_check(export->next);
 	}
 
 	preempt_enable_notrace();
-- 
2.22.0.410.gd8fdbe21b5-goog
