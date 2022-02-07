Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2F34ABF75
	for <lists+kvm-ppc@lfdr.de>; Mon,  7 Feb 2022 14:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbiBGND1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 7 Feb 2022 08:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390520AbiBGLy4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 7 Feb 2022 06:54:56 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C2CC0401C3
        for <kvm-ppc@vger.kernel.org>; Mon,  7 Feb 2022 03:54:02 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id s6-20020a0568301e0600b0059ea5472c98so10637235otr.11
        for <kvm-ppc@vger.kernel.org>; Mon, 07 Feb 2022 03:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0wPDtA/8dQY/zt6gEOJb8muHJfhFJHLN9w+AJsq2qv8=;
        b=Yq2ZfuDnaCP7+Zjic66gYVOgXET4dQYW6dH+Mb63R/XwoD3Ju1QLZWom1oF+pljSMe
         G+1VACKUSZ4Kgm9BmF1Vs7Ghq6Yh9PCKT/OiTMrJ/ZlxIGZzgjTUK3ACURS/i9Y1nG4d
         /lDsVTb+14gtrmFwugTl47Uv54fBCtKBP6akpwUGmXe1+AomIj488INIXhl4ci/4LPkd
         NwRabfaO5HczGWGc5bT/rYGYWrG7u/LbEi/pS/QBT0inrDbiNk+qHtdFulMR+l9p1dLu
         vWhaRlMycI80TXwUiMrevIHb8lbpg7uXmulW0Tgn7in5bv+C6gWtfEGgy49eZK4Sle1e
         zkfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0wPDtA/8dQY/zt6gEOJb8muHJfhFJHLN9w+AJsq2qv8=;
        b=TDAqBsVFfkGK08reUi2d+YrX69lU7yCTaDAbsUjmye1j/WSU0wsDt82ogjh40yvH53
         6i/vA2ZN6G3LDwhzloK/vcy3Uv15VhNEx+GJAqSfH8C/+ZTVszabPInyMq9u8XgetNZm
         C0IDNLSVGcBxczM7nu2DMMB269xWTY4Sg13oZDXJZ76fz59h1/dsxPE7cJBsAwd+SwX2
         AdYKkv77tMAOTKQmuvZmGGEGssEINLtY1uEn94ql1ClM7EJUsvGhX2SMU7yJmwxsC5em
         NfDKvNW2bZEy2R2VRy5LWIGvROTCkGfTTlSc/t1cfusfJr+2PmprqGqcPacQf9bDuwVF
         Brtw==
X-Gm-Message-State: AOAM533CaMMWg3guBmkS/XT8sns0ghOPA892WY9khxEPieXMjzcwBWZ/
        K3C983Cn8Lmu+ep2aBAzu9dP2IbOVHc=
X-Google-Smtp-Source: ABdhPJyK2ZOF1n2ZjcUVDShZFG9nZhSBCVpygtRGNJQFmjrqt3pYzHAHUGhB1NKJEMsdBCu0nwcWpQ==
X-Received: by 2002:a05:6830:1084:: with SMTP id y4mr3858234oto.42.1644234842231;
        Mon, 07 Feb 2022 03:54:02 -0800 (PST)
Received: from [192.168.10.222] ([191.193.0.12])
        by smtp.gmail.com with ESMTPSA id d22sm3748614otp.79.2022.02.07.03.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 03:54:01 -0800 (PST)
Message-ID: <6768501a-0cf8-a2d9-df73-5e8185b433fb@gmail.com>
Date:   Mon, 7 Feb 2022 08:53:57 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v7 0/3] spapr: nvdimm: Introduce spapr-nvdimm device
Content-Language: en-US
To:     Shivaprasad G Bhat <sbhat@linux.ibm.com>, clg@kaod.org,
        mst@redhat.com, ani@anisinha.ca, david@gibson.dropbear.id.au,
        groug@kaod.org, imammedo@redhat.com, xiaoguangrong.eric@gmail.com,
        qemu-ppc@nongnu.org
Cc:     qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com,
        nvdimm@lists.linux.dev, kvm-ppc@vger.kernel.org
References: <164396252398.109112.13436924292537517470.stgit@ltczzess4.aus.stglabs.ibm.com>
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <164396252398.109112.13436924292537517470.stgit@ltczzess4.aus.stglabs.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 2/4/22 05:15, Shivaprasad G Bhat wrote:
> If the device backend is not persistent memory for the nvdimm, there
> is need for explicit IO flushes to ensure persistence.
> 
> On SPAPR, the issue is addressed by adding a new hcall to request for
> an explicit flush from the guest when the backend is not pmem.
> So, the approach here is to convey when the hcall flush is required
> in a device tree property. The guest once it knows the device needs
> explicit flushes, makes the hcall as and when required.
> 
> It was suggested to create a new device type to address the
> explicit flush for such backends on PPC instead of extending the
> generic nvdimm device with new property. So, the patch introduces
> the spapr-nvdimm device. The new device inherits the nvdimm device
> with the new bahviour such that if the backend has pmem=no, the
> device tree property is set by default.
> 
> The below demonstration shows the map_sync behavior for non-pmem
> backends.
> (https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/ndctl.py.data/map_sync.c)
> 
> The pmem0 is from spapr-nvdimm with with backend pmem=on, and pmem1 is
> from spapr-nvdimm with pmem=off, mounted as
> /dev/pmem0 on /mnt1 type xfs (rw,relatime,attr2,dax=always,inode64,logbufs=8,logbsize=32k,noquota)
> /dev/pmem1 on /mnt2 type xfs (rw,relatime,attr2,dax=always,inode64,logbufs=8,logbsize=32k,noquota)
> 
> [root@atest-guest ~]# ./mapsync /mnt1/newfile ----> When pmem=on
> [root@atest-guest ~]# ./mapsync /mnt2/newfile ----> when pmem=off
> Failed to mmap  with Operation not supported
> 
> First patch adds the realize/unrealize call backs to the generic device
> for the new device's vmstate registration. The second patch implements
> the hcall, adds the necessary vmstate properties to spapr machine structure
> for carrying the hcall status during save-restore. The nature of the hcall
> being asynchronus, the patch uses aio utilities to offload the flush. The
> third patch introduces the spapr-nvdimm device, adds the device tree
> property for the guest when spapr-nvdimm is used with pmem=no on the
> backend. Also adds new property pmem-override(?, suggest if you have better
> name) to the spapr-nvdimm which hints at forcing the hcall based flushes even
> on pmem backed devices.
> 
> The kernel changes to exploit this hcall is at
> https://github.com/linuxppc/linux/commit/75b7c05ebf9026.patch
> 
> ---

I noted that we have only two nvdimm tests in QEMU, both in tests/qtest/bios-tables-test.c.
It would be a good future improvement to add some spapr-nvdimm tests there as well.


Thanks,


Daniel


> v6 - https://lists.gnu.org/archive/html/qemu-devel/2022-02/msg00322.html
> Changes from v6:
>        - Addressed commen from Daniel.
>          Fixed a typo
>          Fetch the memory backend FD in the flush_worker_cb(), updated hcall
>          return values in the comments description)
>        - Updated the signatures.
> 
> v5 - https://lists.gnu.org/archive/html/qemu-devel/2021-07/msg01741.html
> Changes from v5:
>        - Taken care of all comments from David
>        - Moved the flush lists from spapr machine into the spapr-nvdimm device
>          state structures. So, all corresponding data structures adjusted
> 	accordingly as required.
>        - New property pmem-overrride is added to the spapr-nvdimm device. The
>          hcall flushes are allowed when pmem-override is set for the device.
>        - The flush for pmem backend devices are made to use pmem_persist().
>        - The vmstate structures are also made part of device state instead of
>          global spapr.
>        - Passing the flush token to destination during migration, I think its
>          better than finding, deriving it from the outstanding ones.
> 
> v4 - https://lists.gnu.org/archive/html/qemu-devel/2021-04/msg05982.html
> Changes from v4:
>        - Introduce spapr-nvdimm device with nvdimm device as the parent.
>        - The new spapr-nvdimm has no new properties. As this is a new
>          device and there is no migration related dependencies to be
>          taken care of, the device behavior is made to set the device tree
>          property and enable hcall when the device type spapr-nvdimm is
>          used with pmem=off
>        - Fixed commit messages
>        - Added checks to ensure the backend is actualy file and not memory
>        - Addressed things pointed out by Eric
> 
> v3 - https://lists.gnu.org/archive/html/qemu-devel/2021-03/msg07916.html
> Changes from v3:
>        - Fixed the forward declaration coding guideline violations in 1st patch.
>        - Removed the code waiting for the flushes to complete during migration,
>          instead restart the flush worker on destination qemu in post load.
>        - Got rid of the randomization of the flush tokens, using simple
>          counter.
>        - Got rid of the redundant flush state lock, relying on the BQL now.
>        - Handling the memory-backend-ram usage
>        - Changed the sync-dax symantics from on/off to 'unsafe','writeback' and 'direct'.
> 	Added prevention code using 'writeback' on arm and x86_64.
>        - Fixed all the miscellaneous comments.
> 
> v2 - https://lists.gnu.org/archive/html/qemu-devel/2020-11/msg07031.html
> Changes from v2:
>        - Using the thread pool based approach as suggested
>        - Moved the async hcall handling code to spapr_nvdimm.c along
>          with some simplifications
>        - Added vmstate to preserve the hcall status during save-restore
>          along with pre_save handler code to complete all ongoning flushes.
>        - Added hw_compat magic for sync-dax 'on' on previous machines.
>        - Miscellanious minor fixes.
> 
> v1 - https://lists.gnu.org/archive/html/qemu-devel/2020-11/msg06330.html
> Changes from v1
>        - Fixed a missed-out unlock
>        - using QLIST_FOREACH instead of QLIST_FOREACH_SAFE while generating token
> 
> Shivaprasad G Bhat (3):
>        nvdimm: Add realize, unrealize callbacks to NVDIMMDevice class
>        spapr: nvdimm: Implement H_SCM_FLUSH hcall
>        spapr: nvdimm: Introduce spapr-nvdimm device
> 
> 
>   hw/mem/nvdimm.c               |  16 ++
>   hw/mem/pc-dimm.c              |   5 +
>   hw/ppc/spapr.c                |   2 +
>   hw/ppc/spapr_nvdimm.c         | 394 ++++++++++++++++++++++++++++++++++
>   include/hw/mem/nvdimm.h       |   2 +
>   include/hw/mem/pc-dimm.h      |   1 +
>   include/hw/ppc/spapr.h        |   4 +-
>   include/hw/ppc/spapr_nvdimm.h |   1 +
>   8 files changed, 424 insertions(+), 1 deletion(-)
> 
> --
> Signature
> 
