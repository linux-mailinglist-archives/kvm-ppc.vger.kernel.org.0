Return-Path: <kvm-ppc+bounces-124-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F4035926338
	for <lists+kvm-ppc@lfdr.de>; Wed,  3 Jul 2024 16:18:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B551F282257
	for <lists+kvm-ppc@lfdr.de>; Wed,  3 Jul 2024 14:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB14D16F0E4;
	Wed,  3 Jul 2024 14:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C8VIOPJ5"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15B0177980;
	Wed,  3 Jul 2024 14:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720016254; cv=none; b=Oc0WagUs2m4nc4a2CXsiN8uwkGu3QcBeuOxpGVoYS2TSOttV3GrpffOkh9jBdUmE9nwLt+JrVmvTX6Uv4nwLaJBKJwKtjY0qK07M+cnK0DEVZBO0BhEWYoCvVRMh44SorT9NbqdfSLMrCmZCVDit/TY+ObrLTCC396FPhUp6zL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720016254; c=relaxed/simple;
	bh=2Xu8QyzbMcla5kLrPvoyh9br/6U7lmTasIff8WH4HOo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n5HOPrldMFUw7foshrZPkhg5bMOtuYJ3tIvNzjSLqyy7vbFA/TRqDElUrzpewwGbo0rua9NiNBHapBarE20ufBSGDGYycvDZkgpTI4Exfx8Y4DnMt61BPY0o2PLmk/2stb+6FOAQNTNqt2G1xXxLfhVrAztvDBbYP9Xl1ZpYgIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C8VIOPJ5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 463DQvC5027116;
	Wed, 3 Jul 2024 14:17:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=nMMPTtYjsheWlXQLNwDkSZKOk6
	2V9YaP8Lxldvz/DSw=; b=C8VIOPJ5TtYEqIkebGRxkuPHNipFX3E8MO2RZfu0bl
	A9sIB8FWN3TgVQY5pXx85IGn7eL/gg5wnJ3VDE5fiwHfbYuetzDMfR9FMXn5M5+b
	vfzUhup3TiNeH+E/8S0aOTp6qNVDbvTRM2QzZKuQfUYGX2WPg2gDTvAcFhekGrz7
	3UZJXnEO82IPx6xvDtZDzBKxwou1fZ4qGECr0/I9jIy93b8c31kgLnO79LaobueL
	6PrUJoHsag7MMEt7JuIAKO9Sd1Jq1ihwXtQJ3S7VEXKKqe1P+q3v76WQC/vxuLl3
	yEpnbFVRcDfiT4yU2OAamGKBIFPLZulpy412ZOynPaEg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 405747g88k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 14:17:11 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 463EHBtH011242;
	Wed, 3 Jul 2024 14:17:11 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 405747g88f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 14:17:11 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 463D0HmT030022;
	Wed, 3 Jul 2024 14:17:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 402x3n2vw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 14:17:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 463EH6rk37421496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Jul 2024 14:17:06 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B574A2004B;
	Wed,  3 Jul 2024 14:17:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B7AF20049;
	Wed,  3 Jul 2024 14:17:02 +0000 (GMT)
Received: from li-e7e2bd4c-2dae-11b2-a85c-bfd29497117c.ibm.com.com (unknown [9.195.35.120])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Jul 2024 14:17:01 +0000 (GMT)
From: Amit Machhiwal <amachhiw@linux.ibm.com>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: kvm-ppc@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh@kernel.org>, Lizhi Hou <lizhi.hou@amd.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>,
        Amit Machhiwal <amachhiw@linux.ibm.com>,
        Kowshik Jois B S <kowsjois@linux.ibm.com>
Subject: [PATCH] PCI: Fix crash during pci_dev hot-unplug on pseries KVM guest
Date: Wed,  3 Jul 2024 19:46:34 +0530
Message-ID: <20240703141634.2974589-1-amachhiw@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZPPPV2DnNJjRUIU_HZGuFKYEn98mNIsq
X-Proofpoint-GUID: QVwLOs4s4-3jTdg6hBX_OroaDcfcWCzX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_09,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=905 clxscore=1011 lowpriorityscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407030102

With CONFIG_PCI_DYNAMIC_OF_NODES [1], a hot-plug and hot-unplug sequence
of a PCI device attached to a PCI-bridge causes following kernel Oops on
a pseries KVM guest:

 RTAS: event: 2, Type: Hotplug Event (229), Severity: 1
 Kernel attempted to read user page (10ec00000048) - exploit attempt? (uid: 0)
 BUG: Unable to handle kernel data access on read at 0x10ec00000048
 Faulting instruction address: 0xc0000000012d8728
 Oops: Kernel access of bad area, sig: 11 [#1]
 LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
<snip>
 NIP [c0000000012d8728] __of_changeset_entry_invert+0x10/0x1ac
 LR [c0000000012da7f0] __of_changeset_revert_entries+0x98/0x180
 Call Trace:
 [c00000000bcc3970] [c0000000012daa60] of_changeset_revert+0x58/0xd8
 [c00000000bcc39c0] [c000000000d0ed78] of_pci_remove_node+0x74/0xb0
 [c00000000bcc39f0] [c000000000cdcfe0] pci_stop_bus_device+0xf4/0x138
 [c00000000bcc3a30] [c000000000cdd140] pci_stop_and_remove_bus_device_locked+0x34/0x64
 [c00000000bcc3a60] [c000000000cf3780] remove_store+0xf0/0x108
 [c00000000bcc3ab0] [c000000000e89e04] dev_attr_store+0x34/0x78
 [c00000000bcc3ad0] [c0000000007f8dd4] sysfs_kf_write+0x70/0xa4
 [c00000000bcc3af0] [c0000000007f7248] kernfs_fop_write_iter+0x1d0/0x2e0
 [c00000000bcc3b40] [c0000000006c9b08] vfs_write+0x27c/0x558
 [c00000000bcc3bf0] [c0000000006ca168] ksys_write+0x90/0x170
 [c00000000bcc3c40] [c000000000033248] system_call_exception+0xf8/0x290
 [c00000000bcc3e50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec
<snip>

A git bisect pointed this regression to be introduced via [1] that added
a mechanism to create device tree nodes for parent PCI bridges when a
PCI device is hot-plugged.

The Oops is caused when `pci_stop_dev()` tries to remove a non-existing
device-tree node associated with the pci_dev that was earlier
hot-plugged and was attached under a pci-bridge. The PCI dev header
`dev->hdr_type` being 0, results a conditional check done with
`pci_is_bridge()` into false. Consequently, a call to
`of_pci_make_dev_node()` to create a device node is never made. When at
a later point in time, in the device node removal path, a memcpy is
attempted in `__of_changeset_entry_invert()`; since the device node was
never created, results in an Oops due to kernel read access to a bad
address.

To fix this issue the patch updates `pci_stop_dev()` to ensure that a
call to `of_pci_remove_node()` is only made for pci-bridge devices.

[1] commit 407d1a51921e ("PCI: Create device tree node for bridge")

Fixes: 407d1a51921e ("PCI: Create device tree node for bridge")
Reported-by: Kowshik Jois B S <kowsjois@linux.ibm.com>
Tested-by: Kowshik Jois B S <kowsjois@linux.ibm.com>
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
---
 drivers/pci/remove.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index d749ea8250d6..4e51c64af416 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -22,7 +22,8 @@ static void pci_stop_dev(struct pci_dev *dev)
 		device_release_driver(&dev->dev);
 		pci_proc_detach_device(dev);
 		pci_remove_sysfs_dev_files(dev);
-		of_pci_remove_node(dev);
+		if (pci_is_bridge(dev))
+			of_pci_remove_node(dev);
 
 		pci_dev_assign_added(dev, false);
 	}

base-commit: e9d22f7a6655941fc8b2b942ed354ec780936b3e
-- 
2.45.2


