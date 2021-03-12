Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFC73387AB
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Mar 2021 09:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhCLIjh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 12 Mar 2021 03:39:37 -0500
Received: from mail-eopbgr750051.outbound.protection.outlook.com ([40.107.75.51]:5510
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232301AbhCLIjU (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 12 Mar 2021 03:39:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCRKYLsk0J61g+A8mqtt9IPHwvRVspeyUAsFn2LXCOg6u57I1N/inYmV0VisdviG09CWNtF1dxGxPXO2jGp8VljMliM1CeNZ/IOlcIgkqRVxxtRuM/DqsdkwtkDW6+PQCibbkCthno8VxCGzSQlfkkavNBcU0ZaobS0pBCkv2m4xL/ED7vd3AjPy3Lu+F7+dw4B4QEM/WV6Ezz0X9ipbUnte99NV76YqkUMFBFtARzK3AYFbttaxq6FGQcVBF7QxNJwfwk7bfzmkdKFixeI/dAVsUcdSCQueXsSddM1MrMDbjuia0w6S1Pf85/tBcyuGXQqwLuFWmxBmSbfJov+H2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iheuNJz7RXNm8r1gEKLmd8v8UDVPYB/wb+Vsc4S6fDs=;
 b=PNNdBm6X1uyZNKsXZrk9MEr0nNsGYZi3geLkTNjMvVHLzBnLacsbxZSX9a5LZrVWGCavcPXw021YDr03C6bB5c9sArTrZgy7EtmL2UGOkAyjiJZ+dSVHynfxRUsYrJkRLcat8AHu2yzQKu6vNRYx2jY1SB15oI2g7MHQXXamUroGnqehN8eIurPkKRyG7J/nGmHJlgmYos1JdF6fvHsuvSayWLzseMPLcS2XZ2ciBfmqugFuhB2eJvHnldOqEbhoapEHtXmhvOtDLZ/uL3FmSMdTCgCWGgU6waIbhr9olf7O/QAShrvt8anW7Pi7rSGDs3opiIzO5+rpVz/SwLwomA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iheuNJz7RXNm8r1gEKLmd8v8UDVPYB/wb+Vsc4S6fDs=;
 b=ms4LZTAT9qxcLMkdLMPefEy+C58fm6Rm0Nn3m9qwgLUTdjJLm54cqtj4ORyx157qxyerswBqsAhTwa3XarW4QsthNkiVH+pPyAAmQTLk3maVOe159I/MaGLzogWRxcz7w55woQuqlfq/qCyWwQvkME1mwSstcDC7lHLV/TWfKxfk8GzvAUldSTGw+bFSVw6OivhYsLvnYbrkl5999YSX5L/UZjBNEYkTt/AOgUph4/mcSFUhnqnEdXRecrKxf/MkmtNLwkwxn5i1JNd1RdCuYGU1iOQ/iOLXfZuA+gm8p0+iPcNLWIM/VYH9D+s94JiWjT6bxYccAGh5PPnbJocvUg==
Received: from DM5PR10CA0012.namprd10.prod.outlook.com (2603:10b6:4:2::22) by
 CH2PR12MB4117.namprd12.prod.outlook.com (2603:10b6:610:ae::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Fri, 12 Mar 2021 08:39:16 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:2:cafe::e9) by DM5PR10CA0012.outlook.office365.com
 (2603:10b6:4:2::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.21 via Frontend
 Transport; Fri, 12 Mar 2021 08:39:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 08:39:16 +0000
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 08:39:15 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     <linux-mm@kvack.org>, <nouveau@lists.freedesktop.org>,
        <bskeggs@redhat.com>, <akpm@linux-foundation.org>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <jhubbard@nvidia.com>, <rcampbell@nvidia.com>,
        <jglisse@redhat.com>, <jgg@nvidia.com>, <hch@infradead.org>,
        <daniel@ffwll.ch>, <willy@infradead.org>,
        Alistair Popple <apopple@nvidia.com>
Subject: [PATCH v6 0/8] Add support for SVM atomics in Nouveau
Date:   Fri, 12 Mar 2021 19:38:43 +1100
Message-ID: <20210312083851.15981-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8abfa89-2664-4c41-5c62-08d8e532521c
X-MS-TrafficTypeDiagnostic: CH2PR12MB4117:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4117E26B793434014E26A2C0DF6F9@CH2PR12MB4117.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jw0uqvtIXSGnoAv/4npDgMlK6d+lX4g4KZXDrOdqztco/WXI4kktH6rRY7a6l6f8Enu8b+EsxVcPPbsvspHCaBITAWJAA5yufzUjcPYsLDUcioUj/y9KXR6ev6nPS0kY1p9DjcQXxzwkOZnW77t/SNBb8XyRh2qycaCdDT1gG1h+XfPwBhDKopM9+/02W2ql5V1oAyPWwPimK+6eC+ao4T5ypYT3wki0C6cOmDYHySMT+QAl+I9VLfWJbkbV8GOGQ3vKBsgNXWxXsNgxhIFN4bCXutD5i3D2nnjVf/E0EBHtSYpeU1VV1OR9L+oGQ8hKx3AmbbIYRU3Le7cI+vRYeHOoCRyf8scvhf67Jfnt+F7wiq0A63SNPnw2XuqWRjJXMItc7JMV+SxpGCQl3BMmF0NBHyBBHohZGOfXxzgBQPMa8GRMYenSLftuYq2bFw+DtW6eoBfczelESfOJQH1swgctzoJCaHubjcgIja+PzPOA4S0nWhd055Usjvfluf1JIzmbkFrR/e0ZIa+uCsfnGncPoDsRX4X+iBZMRLB10yQZxUpWUe0WE8EbOQBBfwqldiHb/sod/29O6IvhYHnEL6Rx7S87Yi6weas120bmABDuncCoAmaa7ulCFfXBpgbUMzbN0bSSOthHLra2DJT6yXOYgpMZBxT2dQ0thLawlx12HuI1VzDa8fOKH1CTyLH0
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(396003)(376002)(36840700001)(46966006)(70206006)(70586007)(16526019)(26005)(186003)(2906002)(36860700001)(336012)(86362001)(7416002)(426003)(2616005)(47076005)(478600001)(34020700004)(8676002)(6666004)(4326008)(36906005)(54906003)(316002)(36756003)(356005)(83380400001)(5660300002)(110136005)(1076003)(107886003)(7636003)(82310400003)(82740400003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 08:39:16.0481
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8abfa89-2664-4c41-5c62-08d8e532521c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4117
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is the sixth version of a series to add support to Nouveau for atomic
memory operations on OpenCL shared virtual memory (SVM) regions.

There are no significant changes for version six other than correcting a
minor s390 build and bisectability issue and removing a redundant call to
compound_page() when checking for PageLocked in patch 1.

Exclusive device access is implemented by adding a new swap entry type
(SWAP_DEVICE_EXCLUSIVE) which is similar to a migration entry. The main
difference is that on fault the original entry is immediately restored by
the fault handler instead of waiting.

Restoring the entry triggers calls to MMU notifers which allows a device
driver to revoke the atomic access permission from the GPU prior to the CPU
finalising the entry.

Patches 1 & 2 refactor existing migration and device private entry
functions.

Patches 3 & 4 rework try_to_unmap_one() by splitting out unrelated
functionality into separate functions - try_to_migrate_one() and
try_to_munlock_one(). These should not change any functionality, but any
help testing would be much appreciated as I have not been able to test
every usage of try_to_unmap_one().

Patch 5 contains the bulk of the implementation for device exclusive
memory.

Patch 6 contains some additions to the HMM selftests to ensure everything
works as expected.

Patch 7 is a cleanup for the Nouveau SVM implementation.

Patch 8 contains the implementation of atomic access for the Nouveau
driver.

This has been tested using the latest upstream Mesa userspace with a simple
OpenCL test program which checks the results of atomic GPU operations on a
SVM buffer whilst also writing to the same buffer from the CPU.

Alistair Popple (8):
  mm: Remove special swap entry functions
  mm/swapops: Rework swap entry manipulation code
  mm/rmap: Split try_to_munlock from try_to_unmap
  mm/rmap: Split migration into its own function
  mm: Device exclusive memory access
  mm: Selftests for exclusive device memory
  nouveau/svm: Refactor nouveau_range_fault
  nouveau/svm: Implement atomic SVM access

 Documentation/vm/hmm.rst                      |  19 +-
 arch/s390/mm/pgtable.c                        |   2 +-
 drivers/gpu/drm/nouveau/include/nvif/if000c.h |   1 +
 drivers/gpu/drm/nouveau/nouveau_svm.c         | 130 +++-
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.h |   1 +
 .../drm/nouveau/nvkm/subdev/mmu/vmmgp100.c    |   6 +
 fs/proc/task_mmu.c                            |  23 +-
 include/linux/mmu_notifier.h                  |  25 +-
 include/linux/rmap.h                          |   9 +-
 include/linux/swap.h                          |   8 +-
 include/linux/swapops.h                       | 123 ++--
 lib/test_hmm.c                                | 126 +++-
 lib/test_hmm_uapi.h                           |   2 +
 mm/debug_vm_pgtable.c                         |  12 +-
 mm/hmm.c                                      |  12 +-
 mm/huge_memory.c                              |  45 +-
 mm/hugetlb.c                                  |  10 +-
 mm/memcontrol.c                               |   2 +-
 mm/memory.c                                   | 127 +++-
 mm/migrate.c                                  |  41 +-
 mm/mprotect.c                                 |  18 +-
 mm/page_vma_mapped.c                          |  15 +-
 mm/rmap.c                                     | 597 +++++++++++++++---
 tools/testing/selftests/vm/hmm-tests.c        | 219 +++++++
 24 files changed, 1313 insertions(+), 260 deletions(-)

-- 
2.20.1

