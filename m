Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00102A1B7
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 May 2019 01:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfEXXtx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 May 2019 19:49:53 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41341 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfEXXtw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 May 2019 19:49:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id q17so1345894pfq.8
        for <kvm-ppc@vger.kernel.org>; Fri, 24 May 2019 16:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bXWjSqu/FFDZjQmYhe/qCEvEUInVu4DGSKgcOvRdwjk=;
        b=SSXTBiyMSX/oc9HkyPWBiENbVB5RnisYOqxhJCIZctnnw4EmW8cl8FzFFjAH+4NrfU
         ycGfsE5BYbGlQVqUDXG2lz9tDP3wyv961R0l1Ds9cgmFUTBciKFz4usoD8uCV/iZ1yXu
         0zf3fcT+r3UfqasFzvYgNdH1NARFxk7hru+xU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bXWjSqu/FFDZjQmYhe/qCEvEUInVu4DGSKgcOvRdwjk=;
        b=NopbQitYXqwOwtmQb84bR2bnwx4+Q9q3U5+URc8mluVwoHj6CIkQ1eElztov2ethaQ
         igFqH6/R/bx6UGLbeNY195vo14ubbqtPLGusOojqjmfdMJxHjGU8V0ZxmqnJ3EpCzy4E
         uYc65G4Ktv1zsZZ8M8+sErLHw3QVNt2eZ/HLykwiNd+I3h/gbg4bJvHA5DdCIL6QQXLP
         lpuAI7nDgd9wdFiwACdyLDtxPFiOipuQNGVaxCtz58gUcPb977eLJVVgAF9ciCW+jx32
         OzSS+Bz6F9Ds5oyKMleLagDGVOkyp1T2oIEmyYhZNoz0LZ2LjboRJryySi199nIg68TG
         29WA==
X-Gm-Message-State: APjAAAUiNMO9hgrC6VAnmsSYVV5qq2k6ky9Ov4ORh8y9k4O8FWwzpy1H
        o9VDBLSYn/DsGXyJoq1BcRVDZw==
X-Google-Smtp-Source: APXvYqwYPAfpLOZID2qY5FFKB8wspcViNi7JQIMMdziXW7MOAadx9VfLL1DAMlFCYOxsbuu8c0vHmg==
X-Received: by 2002:a62:7d10:: with SMTP id y16mr116480258pfc.116.1558741792000;
        Fri, 24 May 2019 16:49:52 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id q4sm3297595pgb.39.2019.05.24.16.49.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 16:49:50 -0700 (PDT)
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
Subject: [PATCH RFC 0/5] Remove some notrace RCU APIs
Date:   Fri, 24 May 2019 19:49:28 -0400
Message-Id: <20190524234933.5133-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The series removes users of the following APIs, and the APIs themselves, since
the regular non - _notrace variants don't do any tracing anyway.
 * hlist_for_each_entry_rcu_notrace
 * rcu_dereference_raw_notrace

Joel Fernandes (Google) (5):
powerpc: Use regular rcu_dereference_raw API
trace: Use regular rcu_dereference_raw API
hashtable: Use the regular hlist_for_each_entry_rcu API
rculist: Remove hlist_for_each_entry_rcu_notrace since no users
rcu: Remove rcu_dereference_raw_notrace since no users

.clang-format                                 |  1 -
.../RCU/Design/Requirements/Requirements.html |  6 +++---
arch/powerpc/include/asm/kvm_book3s_64.h      |  2 +-
include/linux/hashtable.h                     |  2 +-
include/linux/rculist.h                       | 20 -------------------
include/linux/rcupdate.h                      |  9 ---------
kernel/trace/ftrace.c                         |  4 ++--
kernel/trace/ftrace_internal.h                |  8 ++++----
kernel/trace/trace.c                          |  4 ++--
9 files changed, 13 insertions(+), 43 deletions(-)

--
2.22.0.rc1.257.g3120a18244-goog

