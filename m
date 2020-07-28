Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2C1230215
	for <lists+kvm-ppc@lfdr.de>; Tue, 28 Jul 2020 07:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgG1FwW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 28 Jul 2020 01:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgG1FwV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 28 Jul 2020 01:52:21 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D31C061794
        for <kvm-ppc@vger.kernel.org>; Mon, 27 Jul 2020 22:52:21 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4BG5RS0PTBz9sTm; Tue, 28 Jul 2020 15:52:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1595915540; bh=+4m+nip6A1Fn0hjlDbrbBLcZlqpgnvDS+IvWIylIUoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ay5dsS9/nml08EXtk/F7vGZhCVU7DszWdML4byQEKIHcxOlW9J+tLzRDW9WkaOJGW
         eAg1Q+nToPJCAzECLhEHktA7yy52iBwJNTQzs+vjci893uit6NQt+fV/BTt9m4d/CC
         NSNupufIUHS1wnD4azy97HsfLugKmuxU32D9BF/rXoXWh9SemJ3uQzIpxDJbJHeWnw
         MqwFIahGF7EeANpoZtUXEG91UBzgAYcKt6ZRxfo0fOp5lVSYcXGQQXhSrE6EmUftU5
         ch6mDVGYINSladlsZkQzTvVDPZ+1RTD5Q3+XdJk8G+6OkBvLFoshqcPthPiaKtHf8j
         jyF5m5mFDZP5w==
Date:   Tue, 28 Jul 2020 15:52:15 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, sathnaga@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/2] Rework secure memslot dropping
Message-ID: <20200728055215.GC2460422@thinks.paulus.ozlabs.org>
References: <1595877869-2746-1-git-send-email-linuxram@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595877869-2746-1-git-send-email-linuxram@us.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jul 27, 2020 at 12:24:27PM -0700, Ram Pai wrote:
> From: Laurent Dufour <ldufour@linux.ibm.com>
> 
> When doing memory hotplug on a secure VM, the secure pages are not well
> cleaned from the secure device when dropping the memslot.  This silent
> error, is then preventing the SVM to reboot properly after the following
> sequence of commands are run in the Qemu monitor:
> 
> device_add pc-dimm,id=dimm1,memdev=mem1
> device_del dimm1
> device_add pc-dimm,id=dimm1,memdev=mem1
> 
> At reboot time, when the kernel is booting again and switching to the
> secure mode, the page_in is failing for the pages in the memslot because
> the cleanup was not done properly, because the memslot is flagged as
> invalid during the hot unplug and thus the page fault mechanism is not
> triggered.
> 
> To prevent that during the memslot dropping, instead of belonging on the
> page fault mechanism to trigger the page out of the secured pages, it seems
> simpler to directly call the function doing the page out. This way the
> state of the memslot is not interfering on the page out process.
> 
> This series applies on top of the Ram's one titled:
> "[v6 0/5] Migrate non-migrated pages of a SVM."

Thanks, series applied to my kvm-ppc-next branch and pull request sent.

Paul.
