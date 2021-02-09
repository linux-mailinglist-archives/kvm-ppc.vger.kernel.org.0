Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC65A314548
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Feb 2021 02:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhBIBKG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Feb 2021 20:10:06 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6583 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhBIBKF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Feb 2021 20:10:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021e0c40001>; Mon, 08 Feb 2021 17:09:24 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 01:09:24 +0000
Received: from localhost (172.20.145.6) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb 2021 01:09:23
 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     <linux-mm@kvack.org>, <nouveau@lists.freedesktop.org>,
        <bskeggs@redhat.com>, <akpm@linux-foundation.org>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <jhubbard@nvidia.com>, <rcampbell@nvidia.com>,
        <jglisse@redhat.com>, "Alistair Popple" <apopple@nvidia.com>
Subject: [PATCH 1/9] mm/migrate.c: Always allow device private pages to migrate
Date:   Tue, 9 Feb 2021 12:07:14 +1100
Message-ID: <20210209010722.13839-2-apopple@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210209010722.13839-1-apopple@nvidia.com>
References: <20210209010722.13839-1-apopple@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612832964; bh=oZ4IzPZ4J9LSuy9imywhNP9s/LgdHZ4boj/cGLUh0kU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=DultRc8vIMKcdwumpL2sx++22sXnXh0sI0HuZ45Lo/JxDXE5k6o+YyL/GYNTz+m64
         0QqP3bGnpUovgMWODtNvQk/Izmx8iCPIZR7ecIGqzwuXcQA+QyEQgBRUYmxy3ns5Ho
         A8qCRn6N37XpK8elbFaFAuEbob8gwqIL0x0fK+wmzTEfEcydL3w4TJ+qSPV9Clp84s
         JMx6UviPU/Np/Sb4Vn7B8D3YTl72TMvNDsMCT0oxNWMqn4O1KJaiiXDb/4uND82fQ/
         0HvciJTVMbFEXXIe2sS/THs6zm/8m6Qa6crwneJ9KwZthtQ7c2jmyHPzsZPA0trSS6
         dUawZWcQlMgjg==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Device private pages are used to represent device memory that is not
directly accessible from the CPU. Extra references to a device private
page are only used to ensure the struct page itself remains valid whilst
waiting for migration entries. Therefore extra references should not
prevent device private page migration as this can lead to failures to
migrate pages back to the CPU which are fatal to the user process.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 mm/migrate.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 20ca887ea769..053228559fd3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -405,8 +405,13 @@ int migrate_page_move_mapping(struct address_space *ma=
pping,
 	int nr =3D thp_nr_pages(page);
=20
 	if (!mapping) {
-		/* Anonymous page without mapping */
-		if (page_count(page) !=3D expected_count)
+		/*
+		 * Anonymous page without mapping. Device private pages should
+		 * never have extra references except during migration, but it
+		 * is safe to ignore these.
+		 */
+		if (!is_device_private_page(page) &&
+			page_count(page) !=3D expected_count)
 			return -EAGAIN;
=20
 		/* No turning back from here */
--=20
2.20.1

