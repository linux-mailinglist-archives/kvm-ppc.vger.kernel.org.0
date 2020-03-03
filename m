Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76DA176FA1
	for <lists+kvm-ppc@lfdr.de>; Tue,  3 Mar 2020 07:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgCCGuT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 3 Mar 2020 01:50:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26014 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbgCCGuT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 3 Mar 2020 01:50:19 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0236eRTX139922
        for <kvm-ppc@vger.kernel.org>; Tue, 3 Mar 2020 01:50:17 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yfncdg1te-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 03 Mar 2020 01:50:17 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <clg@fr.ibm.com>;
        Tue, 3 Mar 2020 06:50:15 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 3 Mar 2020 06:50:11 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0236nAiL49086796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Mar 2020 06:49:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E8A9A4059;
        Tue,  3 Mar 2020 06:50:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 901ACA406B;
        Tue,  3 Mar 2020 06:50:08 +0000 (GMT)
Received: from [9.145.182.89] (unknown [9.145.182.89])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Mar 2020 06:50:08 +0000 (GMT)
To:     David Gibson <david@gibson.dropbear.id.au>,
        Ram Pai <linuxram@us.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        mpe@ellerman.id.au, bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org,
        groug@kaod.org
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
 <20200302233240.GB35885@umbus.fritz.box>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@fr.ibm.com>
Date:   Tue, 3 Mar 2020 07:50:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302233240.GB35885@umbus.fritz.box>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20030306-0020-0000-0000-000003AFE5EE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030306-0021-0000-0000-0000220813AC
Message-Id: <8f0c3d41-d1f9-7e6d-276b-b95238715979@fr.ibm.com>
Subject: RE: [RFC PATCH v1] powerpc/prom_init: disable XIVE in Secure VM.
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_01:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1011
 impostorscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030050
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 3/3/20 12:32 AM, David Gibson wrote:
> On Fri, Feb 28, 2020 at 11:54:04PM -0800, Ram Pai wrote:
>> XIVE is not correctly enabled for Secure VM in the KVM Hypervisor yet.
>>
>> Hence Secure VM, must always default to XICS interrupt controller.
>>
>> If XIVE is requested through kernel command line option "xive=on",
>> override and turn it off.
>>
>> If XIVE is the only supported platform interrupt controller; specified
>> through qemu option "ic-mode=xive", simply abort. Otherwise default to
>> XICS.
> 
> Uh... the discussion thread here seems to have gotten oddly off
> track.  

There seem to be multiple issues. It is difficult to have a clear status.

> So, to try to clean up some misunderstandings on both sides:
> 
>   1) The guest is the main thing that knows that it will be in secure
>      mode, so it's reasonable for it to conditionally use XIVE based
>      on that

FW support is required AFAIUI.

>   2) The mechanism by which we do it here isn't quite right.  Here the
>      guest is checking itself that the host only allows XIVE, but we
>      can't do XIVE and is panic()ing.  Instead, in the SVM case we
>      should force support->xive to false, and send that in the CAS
>      request to the host.  We expect the host to just terminate
>      us because of the mismatch, but this will interact better with
>      host side options setting policy for panic states and the like.
>      Essentially an SVM kernel should behave like an old kernel with
>      no XIVE support at all, at least w.r.t. the CAS irq mode flags.

Yes. XIVE shouldn't be requested by the guest. This is the last option 
I proposed but I thought there was some negotiation with the hypervisor
which is not the case. 

>   3) Although there are means by which the hypervisor can kind of know
>      a guest is in secure mode, there's not really an "svm=on" option
>      on the host side.  For the most part secure mode is based on
>      discussion directly between the guest and the ultravisor with
>      almost no hypervisor intervention.

Is there a negotiation with the ultravisor ? 

>   4) I'm guessing the problem with XIVE in SVM mode is that XIVE needs
>      to write to event queues in guest memory, which would have to be
>      explicitly shared for secure mode.  That's true whether it's KVM
>      or qemu accessing the guest memory, so kernel_irqchip=on/off is
>      entirely irrelevant.

This problem should be already fixed. The XIVE event queues are shared 
and the remaining problem with XIVE is the KVM page fault handler 
populating the TIMA and ESB pages. Ultravisor doesn't seem to support
this feature and this breaks interrupt management in the guest. 

But, kernel_irqchip=off should work out of the box. It seems it doesn't. 
Something to investigate.

> 
>   5) All the above said, having to use XICS is pretty crappy.  You
>      should really get working on XIVE support for secure VMs.

Yes. 

Thanks,

C.

