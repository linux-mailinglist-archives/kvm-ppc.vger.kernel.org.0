Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8635721A36A
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Jul 2020 17:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgGIPVq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 9 Jul 2020 11:21:46 -0400
Received: from floodgap.com ([66.166.122.164]:61306 "EHLO floodgap.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726662AbgGIPVq (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 9 Jul 2020 11:21:46 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2020 11:21:46 EDT
Received: (from spectre@localhost)
        by floodgap.com (6.6.6.666.1/2015.03.25) id 069FGCsT23462070
        for kvm-ppc@vger.kernel.org; Thu, 9 Jul 2020 08:16:12 -0700
From:   Cameron Kaiser <spectre@floodgap.com>
Message-Id: <202007091516.069FGCsT23462070@floodgap.com>
Subject: Re: [PATCH v2 2/3] powerpc/64s: remove PROT_SAO support
In-Reply-To: <1594288843.m3s9igh1hu.astroid@bobo.none> from Nicholas Piggin at "Jul 9, 20 08:20:23 pm"
To:     kvm-ppc@vger.kernel.org
Date:   Thu, 9 Jul 2020 08:16:12 -0700 (PDT)
X-Mailer: ELM [version 2.4ME+ PL39 (25)]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

> It would probably be better to disallow SAO on all machines than have
> it available on some hosts and not others.  (Yes I know there is a
> check on CPU_FTR_ARCH_206 in there, but that has been a no-op since we
> removed the PPC970 KVM support.)

May I ask a very stupid question here -- is that meant to imply KVM
cannot emulate a 970, or that KVM (at least HV, anyway) won't work on a 970?

-- 
------------------------------------ personal: http://www.cameronkaiser.com/ --
  Cameron Kaiser * Floodgap Systems * www.floodgap.com * ckaiser@floodgap.com
-- This is an Honour System Virus. Please delete all your files. Thank you. ---
