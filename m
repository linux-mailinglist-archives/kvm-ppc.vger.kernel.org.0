Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CDF3AAA5F
	for <lists+kvm-ppc@lfdr.de>; Thu, 17 Jun 2021 06:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhFQEoF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 17 Jun 2021 00:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhFQEoD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 17 Jun 2021 00:44:03 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8721FC06175F
        for <kvm-ppc@vger.kernel.org>; Wed, 16 Jun 2021 21:41:55 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id l28-20020a63571c0000b02902224bbd5ea1so2858855pgb.16
        for <kvm-ppc@vger.kernel.org>; Wed, 16 Jun 2021 21:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U4a+eAtSrNPiykYEk9Vgq/hhEodP6uSenpkmEUr1f7c=;
        b=Is9LtlLpb8pT4wch05ptd+CROnT5TvRJ5RL1DQzQIqqnJMsqvtpABM2zfz6+3Nd/Pe
         BI8AK9GaYoSO+EjqAXO6DrMv+IdDBuUspaOgRhXEtGaW9gABYLdywOLRCbxCego/i0BD
         URHmYx9hHYd5Xam/3UpJ5ux3z9d2yz5ptHHS1MBQq3AdkP+tdWEVnzXEkosaLX9Ayed5
         O9WgqGInx7pId+/txZJ/w+Pt7EytFignxR6C1SVqiJBF1SwxY/WJmuq5cou55yC/XhDg
         BCTnbiRoFYuXZ2644BHMp2yTn4lYiG6bNMKnxhy/ETP9sHfHzZZUM6CBy72j9Z/gJzyA
         2wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U4a+eAtSrNPiykYEk9Vgq/hhEodP6uSenpkmEUr1f7c=;
        b=rC6JIzPbBPC8I6jn5F3ZODbS+1i8hvYC9nucKa59yOkbjhRpgySTXWMUMXSg6iVcQM
         OgWjIINKiM7xvngf/0aE9GGH8Rhhq/B9GLuP9fVaYGhPCOszP3BaH//cGVSEKYTY31oK
         2ulR74Gy07i7f4x/JtbOB5MvCh9cz26tfUNSJrXj7GCIHfXsg0iqkShUVoJjWJCHYVyn
         ZW2nLh94g2CCd6UaYN42e94HoXqvJrLstuQmmlgduneds1Sy7NeuBdxhJMwO9JiuNEXk
         bYtozdfapKTlVB8iu9dr84rk+FCvWD53Us+JnxnZ+EH+3kstKBP6iBG3OeEL5Ugh7LtM
         f1ng==
X-Gm-Message-State: AOAM531745eC52e+WIVZdF1aKO9fqo3nJVBQvpb9nfQoZX+Y4Bdw81V3
        XFP9YgWgAOcE2xxFbe/ps+Jp/onnq/AtS1P+ww==
X-Google-Smtp-Source: ABdhPJyn4Yv/izfsk7V1x12ukWXqBvtXWifAN+0b1zIipRQ7zK3AcJH4U5AzWZ9EXcUED2e4JHNf0M9lMqklBuarrA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:aa7:80d9:0:b029:2ed:49fa:6dc5 with
 SMTP id a25-20020aa780d90000b02902ed49fa6dc5mr3298862pfn.3.1623904915016;
 Wed, 16 Jun 2021 21:41:55 -0700 (PDT)
Date:   Thu, 17 Jun 2021 04:41:44 +0000
In-Reply-To: <20210617044146.2667540-1-jingzhangos@google.com>
Message-Id: <20210617044146.2667540-4-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210617044146.2667540-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v10 3/5] KVM: stats: Add documentation for binary statistics interface
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Fuad Tabba <tabba@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This new API provides a file descriptor for every VM and VCPU to read
KVM statistics data in binary format.
It is meant to provide a lightweight, flexible, scalable and efficient
lock-free solution for user space telemetry applications to pull the
statistics data periodically for large scale systems. The pulling
frequency could be as high as a few times per second.
The statistics descriptors are defined by KVM in kernel and can be
by userspace to discover VM/VCPU statistics during the one-time setup
stage.
The statistics data itself could be read out by userspace telemetry
periodically without any extra parsing or setup effort.
There are a few existed interface protocols and definitions, but no
one can fulfil all the requirements this interface implemented as
below:
1. During high frequency periodic stats reading, there should be no
   extra efforts except the stats data read itself.
2. Support stats annotation, like type (cumulative, instantaneous,
   peak, histogram, etc) and unit (counter, time, size, cycles, etc).
3. The stats data reading should be free of lock/synchronization. We
   don't care about the consistency between all the stats data. All
   stats data can not be read out at exactly the same time. We really
   care about the change or trend of the stats data. The lock-free
   solution is not just for efficiency and scalability, also for the
   stats data accuracy and usability. For example, in the situation
   that all the stats data readings are protected by a global lock,
   if one VCPU died somehow with that lock held, then all stats data
   reading would be blocked, then we have no way from stats data that
   which VCPU has died.
4. The stats data reading workload can be handed over to other
   unprivileged process.

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 177 ++++++++++++++++++++++++++++++++-
 1 file changed, 176 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e328caa35d6c..35ee52dbec89 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5034,7 +5034,6 @@ see KVM_XEN_VCPU_SET_ATTR above.
 The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
 with the KVM_XEN_VCPU_GET_ATTR ioctl.
 
-
 4.131 KVM_GET_SREGS2
 ------------------
 
@@ -5081,6 +5080,174 @@ Writes special registers into the vcpu.
 See KVM_GET_SREGS2 for the data structures.
 This ioctl (when supported) replaces the KVM_SET_SREGS.
 
+4.133 KVM_GET_STATS_FD
+----------------------
+
+:Capability: KVM_CAP_STATS_BINARY_FD
+:Architectures: all
+:Type: vm ioctl, vcpu ioctl
+:Parameters: none
+:Returns: statistics file descriptor on success, < 0 on error
+
+Errors:
+
+  ======     ======================================================
+  ENOMEM     if the fd could not be created due to lack of memory
+  EMFILE     if the number of opened files exceeds the limit
+  ======     ======================================================
+
+The file descriptor can be used to read VM/vCPU statistics data in binary
+format. The file data is organized into three blocks as below:
++-------------+
+|   Header    |
++-------------+
+| Descriptors |
++-------------+
+| Stats Data  |
++-------------+
+
+The Header block is always at the start of the file. It is only needed to be
+read one time for the lifetime of the file descriptor.
+It is in the form of ``struct kvm_stats_header`` as below::
+
+	#define KVM_STATS_ID_MAXLEN		64
+
+	struct kvm_stats_header {
+		__u32 name_size;
+		__u32 count;
+		__u32 desc_offset;
+		__u32 data_offset;
+		char id[0];
+	};
+
+The ``id`` field is identification for the corresponding KVM statistics. For
+VM statistics, it is in the form of "kvm-{kvm pid}", like "kvm-12345". For
+VCPU statistics, it is in the form of "kvm-{kvm pid}/vcpu-{vcpu id}", like
+"kvm-12345/vcpu-12".
+
+The ``name_size`` field is the size (byte) of the statistics name string
+(including trailing '\0') appended to the end of every statistics descriptor.
+
+The ``count`` field is the number of statistics.
+
+The ``desc_offset`` field is the offset of the Descriptors block from the start
+of the file indicated by the file descriptor.
+
+The ``data_offset`` field is the offset of the Stats Data block from the start
+of the file indicated by the file descriptor.
+
+The Descriptors block is only needed to be read once for the lifetime of the
+file descriptor. It is an array of ``struct kvm_stats_desc`` as shown in
+below code block::
+
+	#define KVM_STATS_TYPE_SHIFT		0
+	#define KVM_STATS_TYPE_MASK		(0xF << KVM_STATS_TYPE_SHIFT)
+	#define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
+	#define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
+	#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_INSTANT
+
+	#define KVM_STATS_UNIT_SHIFT		4
+	#define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
+	#define KVM_STATS_UNIT_NONE		(0x0 << KVM_STATS_UNIT_SHIFT)
+	#define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
+	#define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
+	#define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
+	#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
+
+	#define KVM_STATS_BASE_SHIFT		8
+	#define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)
+	#define KVM_STATS_BASE_POW10		(0x0 << KVM_STATS_BASE_SHIFT)
+	#define KVM_STATS_BASE_POW2		(0x1 << KVM_STATS_BASE_SHIFT)
+	#define KVM_STATS_BASE_MAX		KVM_STATS_BASE_POW2
+
+	struct kvm_stats_desc {
+		__u32 flags;
+		__s16 exponent;
+		__u16 size;
+		__u32 offset;
+		__u32 unused;
+		char name[0];
+	};
+
+The ``flags`` field contains the type and unit of the statistics data described
+by this descriptor. The following flags are supported:
+
+Bits 0-3 of ``flags`` encode the type:
+  * ``KVM_STATS_TYPE_CUMULATIVE``
+    The statistics data is cumulative. The value of data can only be increased.
+    Most of the counters used in KVM are of this type.
+    The corresponding ``count`` field for this type is always 1.
+  * ``KVM_STATS_TYPE_INSTANT``
+    The statistics data is instantaneous. Its value can be increased or
+    decreased. This type is usually used as a measurement of some resources,
+    like the number of dirty pages, the number of large pages, etc.
+    The corresponding ``count`` field for this type is always 1.
+
+Bits 4-7 of ``flags`` encode the unit:
+  * ``KVM_STATS_UNIT_NONE``
+    There is no unit for the value of statistics data. This usually means that
+    the value is a simple counter of an event.
+  * ``KVM_STATS_UNIT_BYTES``
+    It indicates that the statistics data is used to measure memory size, in the
+    unit of Byte, KiByte, MiByte, GiByte, etc. The unit of the data is
+    determined by the ``exponent`` field in the descriptor. The
+    ``KVM_STATS_BASE_POW2`` flag is valid in this case. The unit of the data is
+    determined by ``pow(2, exponent)``. For example, if value is 10,
+    ``exponent`` is 20, which means the unit of statistics data is MiByte, we
+    can get the statistics data in the unit of Byte by
+    ``value * pow(2, exponent) = 10 * pow(2, 20) = 10 MiByte`` which is
+    10 * 1024 * 1024 Bytes.
+  * ``KVM_STATS_UNIT_SECONDS``
+    It indicates that the statistics data is used to measure time/latency, in
+    the unit of nanosecond, microsecond, millisecond and second. The unit of the
+    data is determined by the ``exponent`` field in the descriptor. The
+    ``KVM_STATS_BASE_POW10`` flag is valid in this case. The unit of the data
+    is determined by ``pow(10, exponent)``. For example, if value is 2000000,
+    ``exponent`` is -6, which means the unit of statistics data is microsecond,
+    we can get the statistics data in the unit of second by
+    ``value * pow(10, exponent) = 2000000 * pow(10, -6) = 2 seconds``.
+  * ``KVM_STATS_UNIT_CYCLES``
+    It indicates that the statistics data is used to measure CPU clock cycles.
+    The ``KVM_STATS_BASE_POW10`` flag is valid in this case. For example, if
+    value is 200, ``exponent`` is 4, we can get the number of CPU clock cycles
+    by ``value * pow(10, exponent) = 200 * pow(10, 4) = 2000000``.
+
+Bits 8-11 of ``flags`` encode the base:
+  * ``KVM_STATS_BASE_POW10``
+    The scale is based on power of 10. It is used for measurement of time and
+    CPU clock cycles.
+  * ``KVM_STATS_BASE_POW2``
+    The scale is based on power of 2. It is used for measurement of memory size.
+
+The ``exponent`` field is the scale of corresponding statistics data. For
+example, if the unit is ``KVM_STATS_UNIT_BYTES``, the base is
+``KVM_STATS_BASE_POW2``, the ``exponent`` is 10, then we know that the real
+unit of the statistics data is KBytes a.k.a pow(2, 10) = 1024 bytes.
+
+The ``size`` field is the number of values (u64) of this statistics data. Its
+value is usually 1 for most of simple statistics.
+
+The ``offset`` field is the offset from the start of Data Block to the start of
+the corresponding statistics data.
+
+The ``unused`` fields are reserved for future support for other types of
+statistics data, like log/linear histogram.
+
+The ``name`` field points to the name string of the statistics data. The name
+string starts at the end of ``struct kvm_stats_desc``.
+The maximum length (including trailing '\0') is indicated by ``name_size``
+in ``struct kvm_stats_header``.
+
+The Stats Data block contains an array of data values of type ``struct
+kvm_vm_stats_data`` or ``struct kvm_vcpu_stats_data``. It would be read by
+userspace periodically to pull statistics data.
+The order of data value in Stats Data block is the same as the order of
+descriptors in Descriptors block.
+  * Statistics data for VM/VCPU::
+
+	struct kvm_stats_data {
+		__u64 value[0];
+	};
 
 5. The kvm_run structure
 ========================
@@ -6969,3 +7136,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_STATS_BINARY_FD
+----------------------------
+
+:Architectures: all
+
+This capability indicates the feature that userspace can create get a file
+descriptor for every VM and VCPU to read statistics data in binary format.
-- 
2.32.0.272.g935e593368-goog

