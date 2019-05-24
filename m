Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA1172A1BA
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 May 2019 01:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfEXXt6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 May 2019 19:49:58 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41347 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbfEXXt5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 May 2019 19:49:57 -0400
Received: by mail-pf1-f195.google.com with SMTP id q17so1345968pfq.8
        for <kvm-ppc@vger.kernel.org>; Fri, 24 May 2019 16:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hSeuL2/o1hJWW7dWBrMonSWjJ1/vxYoP4q+pVJLuGkg=;
        b=pMW9EVUTzAPhotIyQm3Eoarq3hCw8AqUtsXtetNF860gWUcv2atmr+rZJL8mD1CBmy
         qdE9hrxIv04kKXSoaxN2qQ0v8a7rpYSA69+sgvhEa/B71QX44UC2LNZwAGM9BX+SZOUR
         sjB08g4fUlMJZ523g47EtrFR75J8J1VblpgKw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hSeuL2/o1hJWW7dWBrMonSWjJ1/vxYoP4q+pVJLuGkg=;
        b=cm/eSNPiAd5CvgvMoc/gF/goWIGF5cm7Od7I/+RYwlMBCIaofBRVifT+rloO9mtytp
         SnUQDseE6nh1HfaBpVEqe5mr4hd8hsG73TeioWB6AlxPPOJ3mAjiszD2pndBO39EKR88
         nN51ejk69KeRZmMNL+6xCTjXBM+9AfTJmgDWj4Y1HYthllWiLcJiFXnA9GVz+EvE5sId
         ON/Sy+SDaTwgzvrJa5A56NCATqIVUyp3My9SEsbpF6JBO5SVrhNd8P3CC/97X1Ov49m1
         9KNjDQvCV6n8tbZCzGiNlMVOOhX2EcM4YcbV8Zl9DWG4mF0kgeV2pHemDb4jcxE2zGk5
         0SBA==
X-Gm-Message-State: APjAAAVtGhsXQ6GbEOGdZBp9XkRUIYEBtWfGvrfnVOUpOKbLrwYFa9am
        UYecbJ8eZO9fgF0rt5AA6vv0ug==
X-Google-Smtp-Source: APXvYqznegeKjv5vrHpFtq8kqkQovBYm8YPhf3wMKa16Vs+QaEmFvNHAGBfVn1lCiVdh4Es2x2EXHw==
X-Received: by 2002:a62:570a:: with SMTP id l10mr117460057pfb.151.1558741797190;
        Fri, 24 May 2019 16:49:57 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id q4sm3297595pgb.39.2019.05.24.16.49.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 16:49:56 -0700 (PDT)
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
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RFC 2/5] trace: Use regular rcu_dereference_raw API
Date:   Fri, 24 May 2019 19:49:30 -0400
Message-Id: <20190524234933.5133-3-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
In-Reply-To: <20190524234933.5133-1-joel@joelfernandes.org>
References: <20190524234933.5133-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

rcu_dereference_raw already does not do any tracing. There is no need to
use the _notrace variant of it and this series removes that API, so let us
use the regular variant here.

While at it, also replace the only user of
hlist_for_each_entry_rcu_notrace (which indirectly uses the
rcu_dereference_raw_notrace API) with hlist_for_each_entry_rcu which
also does not do any tracing.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 kernel/trace/ftrace.c          | 4 ++--
 kernel/trace/ftrace_internal.h | 8 ++++----
 kernel/trace/trace.c           | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b920358dd8f7..f7d5f0ee69de 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -706,7 +706,7 @@ ftrace_find_profiled_func(struct ftrace_profile_stat *stat, unsigned long ip)
 	if (hlist_empty(hhd))
 		return NULL;
 
-	hlist_for_each_entry_rcu_notrace(rec, hhd, node) {
+	hlist_for_each_entry_rcu(rec, hhd, node) {
 		if (rec->ip == ip)
 			return rec;
 	}
@@ -1135,7 +1135,7 @@ __ftrace_lookup_ip(struct ftrace_hash *hash, unsigned long ip)
 	key = ftrace_hash_key(hash, ip);
 	hhd = &hash->buckets[key];
 
-	hlist_for_each_entry_rcu_notrace(entry, hhd, hlist) {
+	hlist_for_each_entry_rcu(entry, hhd, hlist) {
 		if (entry->ip == ip)
 			return entry;
 	}
diff --git a/kernel/trace/ftrace_internal.h b/kernel/trace/ftrace_internal.h
index 0515a2096f90..e3530a284f46 100644
--- a/kernel/trace/ftrace_internal.h
+++ b/kernel/trace/ftrace_internal.h
@@ -6,22 +6,22 @@
 
 /*
  * Traverse the ftrace_global_list, invoking all entries.  The reason that we
- * can use rcu_dereference_raw_notrace() is that elements removed from this list
+ * can use rcu_dereference_raw() is that elements removed from this list
  * are simply leaked, so there is no need to interact with a grace-period
- * mechanism.  The rcu_dereference_raw_notrace() calls are needed to handle
+ * mechanism.  The rcu_dereference_raw() calls are needed to handle
  * concurrent insertions into the ftrace_global_list.
  *
  * Silly Alpha and silly pointer-speculation compiler optimizations!
  */
 #define do_for_each_ftrace_op(op, list)			\
-	op = rcu_dereference_raw_notrace(list);			\
+	op = rcu_dereference_raw(list);			\
 	do
 
 /*
  * Optimized for just a single item in the list (as that is the normal case).
  */
 #define while_for_each_ftrace_op(op)				\
-	while (likely(op = rcu_dereference_raw_notrace((op)->next)) &&	\
+	while (likely(op = rcu_dereference_raw((op)->next)) &&	\
 	       unlikely((op) != &ftrace_list_end))
 
 extern struct ftrace_ops __rcu *ftrace_ops_list;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ec439999f387..cb8d696d9cde 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2638,10 +2638,10 @@ static void ftrace_exports(struct ring_buffer_event *event)
 
 	preempt_disable_notrace();
 
-	export = rcu_dereference_raw_notrace(ftrace_exports_list);
+	export = rcu_dereference_raw(ftrace_exports_list);
 	while (export) {
 		trace_process_export(export, event);
-		export = rcu_dereference_raw_notrace(export->next);
+		export = rcu_dereference_raw(export->next);
 	}
 
 	preempt_enable_notrace();
-- 
2.22.0.rc1.257.g3120a18244-goog

