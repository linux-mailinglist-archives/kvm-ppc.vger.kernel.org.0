Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0820A160940
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Feb 2020 04:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgBQDuZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 16 Feb 2020 22:50:25 -0500
Received: from mail3-bck.iservicesmail.com ([217.130.24.85]:21589 "EHLO
        mail3-bck.iservicesmail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726485AbgBQDuZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 16 Feb 2020 22:50:25 -0500
IronPort-SDR: Gkgs18IxhuFAQ4hLsxm073L+kQQzkPdAIk4h3O0uhxi6R0bwxt+QlNKvyQezFSnJhXRzbOgwYw
 f6RQw3Xb5U2w==
IronPort-PHdr: =?us-ascii?q?9a23=3AGqASwBVGmsVewLcWUItl3WpbeDvV8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYYxOHt8tkgFKBZ4jH8fUM07OQ7/m8HzNdqsjY+Fk5M7VyFD?=
 =?us-ascii?q?Y9wf0MmAIhBMPXQWbaF9XNKxIAIcJZSVV+9Gu6O0UGUOz3ZlnVv2HgpWVKQk?=
 =?us-ascii?q?a3OgV6PPn6FZDPhMqrye+y54fTYwJVjzahfL9+Nhq7oRjeu8UMg4ZvKqk9xx?=
 =?us-ascii?q?rUrnBVZ+lY2GRkKE6ckBr7+sq+5oNo/T5Ku/Im+c5AUKH6cLo9QLdFEjkoMH?=
 =?us-ascii?q?076dPyuxXbQgSB+nUTUmMNkhpVGAfF9w31Xo3wsiThqOVw3jSRMNDsQrA1XT?=
 =?us-ascii?q?Si6LprSAPthSwaOTM17H3bh8pth69dvRmvpQFww5TMbY+bNPR+ZL3Tc9AHS2?=
 =?us-ascii?q?VOQslfWDdMAp++YoQTE+YNIfpUo5f7qlATrRW+Hw6sBOb3xzFSmHD2wbM10/?=
 =?us-ascii?q?48Gg7G2wwgGd0Ou2nTodXtM6cSS/y1w7PTwDXeafNW2Cz96JTSch87vP6DR6?=
 =?us-ascii?q?h8ccvNyUQ2EQ7Ok1aeqZT9Mj+Ly+gAsXKX4/duWO6zkWIrtQ58riKhy8osjI?=
 =?us-ascii?q?TCm5gbxUre9SpjxYY4Pdi4SElmbtG6CJZQrCSaN5duQsMlXmFopD42yr0Ytp?=
 =?us-ascii?q?6/eygH0JEnyATea/yDaYiH/BbjWPqeLDtimnJlf6+wiAy88UinzO3zSNO430?=
 =?us-ascii?q?hRriZdk9nMsG4C1wDL58SZV/dw/F2t1SuB2gzP8O1IP085mbDVJpMh2rIwk4?=
 =?us-ascii?q?AcsUXHHi/4gkX2i6qWe108+uiv8eTnfq/pq4SBN49yiwH+KbgumtalDuslKA?=
 =?us-ascii?q?cCRWmb+fik2L354UL5WKlKjuExkqTBs5DaO8EbqrehAw9Nzoku8Ai/Dzi439?=
 =?us-ascii?q?QCh3UHL0xKeAiBj4f3P1HCOvf4De2wgwfkrDA+xO7De6X5Cb3TIXXZ1rTsZ7?=
 =?us-ascii?q?Bw7whb0gVg991H44NoDeQ5Le7+QAfOs9rXRkshPhC52fngDtp91YMFU2mnDa?=
 =?us-ascii?q?qQMaeUuliNsLEBOe6JMbcYpDvnY8ci4fGm2Wc+g0MUVbSv3IALcnm0F7JnPx?=
 =?us-ascii?q?PKMjLXnt4dHDJS7UIFR+vwhQjaXA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2EAdQCQDEpelyMYgtlmgkMBGAEBgSM?=
 =?us-ascii?q?CAYFVUiASjGOGa1QGcx+DQ4ZShBGBBYEAgzOGBxMMgVsNAQEBAQE1AgQBAYR?=
 =?us-ascii?q?AggQkPAINAgMNAQEGAQEBAQEFBAEBAhABAQEBAQgWBoVzgjsig3AgDzlKDEA?=
 =?us-ascii?q?BDgGDV4JLAQEKKa0PDQ0ChR6CVgQKgQiBGyOBNgMBAYwhGnmBB4EjIYIrCAG?=
 =?us-ascii?q?CAYJ/ARIBboJIglkEjVISIYlFmDSBaloElmuCOQEPiBaENwOCWg+BC4Mdgwm?=
 =?us-ascii?q?BZ4RSgX+fZoQUV4Egc3EzGggwgW4agSBPGA2ON44rAkCBFxACT4tJgjIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2EAdQCQDEpelyMYgtlmgkMBGAEBgSMCAYFVUiASjGOGa?=
 =?us-ascii?q?1QGcx+DQ4ZShBGBBYEAgzOGBxMMgVsNAQEBAQE1AgQBAYRAggQkPAINAgMNA?=
 =?us-ascii?q?QEGAQEBAQEFBAEBAhABAQEBAQgWBoVzgjsig3AgDzlKDEABDgGDV4JLAQEKK?=
 =?us-ascii?q?a0PDQ0ChR6CVgQKgQiBGyOBNgMBAYwhGnmBB4EjIYIrCAGCAYJ/ARIBboJIg?=
 =?us-ascii?q?lkEjVISIYlFmDSBaloElmuCOQEPiBaENwOCWg+BC4MdgwmBZ4RSgX+fZoQUV?=
 =?us-ascii?q?4Egc3EzGggwgW4agSBPGA2ON44rAkCBFxACT4tJgjIBAQ?=
X-IronPort-AV: E=Sophos;i="5.70,451,1574118000"; 
   d="scan'208";a="337957515"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail02.vodafone.es with ESMTP; 17 Feb 2020 04:50:24 +0100
Received: (qmail 18856 invoked from network); 17 Feb 2020 02:17:37 -0000
Received: from unknown (HELO 192.168.1.163) (mariapazos@[217.217.179.17])
          (envelope-sender <porta@unistrada.it>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <kvm-ppc@vger.kernel.org>; 17 Feb 2020 02:17:37 -0000
Date:   Mon, 17 Feb 2020 03:17:36 +0100 (CET)
From:   Peter Wong <porta@unistrada.it>
Reply-To: Peter Wong <peterwonghkhsbc@gmail.com>
To:     kvm-ppc@vger.kernel.org
Message-ID: <33504745.70549.1581905857061.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Greetings,
Please check the attached email for a buisness proposal to explore.
Looking forward to hearing from you for more details.
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

