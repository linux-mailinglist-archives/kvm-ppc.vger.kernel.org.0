Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E7F17A8F5
	for <lists+kvm-ppc@lfdr.de>; Thu,  5 Mar 2020 16:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgCEPgL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 5 Mar 2020 10:36:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727077AbgCEPgL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 5 Mar 2020 10:36:11 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 025FZreH020749
        for <kvm-ppc@vger.kernel.org>; Thu, 5 Mar 2020 10:36:10 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yjx056gum-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 05 Mar 2020 10:36:10 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <clg@fr.ibm.com>;
        Thu, 5 Mar 2020 15:36:08 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Mar 2020 15:36:05 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 025Fa4gk33096092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Mar 2020 15:36:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5266BAE05A;
        Thu,  5 Mar 2020 15:36:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBE06AE053;
        Thu,  5 Mar 2020 15:36:03 +0000 (GMT)
Received: from [9.101.4.25] (unknown [9.101.4.25])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Mar 2020 15:36:03 +0000 (GMT)
To:     Ram Pai <linuxram@us.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Cc:     Greg Kurz <groug@kaod.org>, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org, mpe@ellerman.id.au,
        bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
 <20200302233240.GB35885@umbus.fritz.box>
 <8f0c3d41-d1f9-7e6d-276b-b95238715979@fr.ibm.com>
 <20200303170205.GA5416@oc0525413822.ibm.com>
 <20200303184520.632be270@bahia.home>
 <20200303185645.GB5416@oc0525413822.ibm.com>
 <20200304115948.7b2dfe10@bahia.home>
 <20200304153727.GH5416@oc0525413822.ibm.com>
 <08269906-db11-b80c-0e67-777ab0aaa9bd@fr.ibm.com>
 <20200304235545.GE593957@umbus.fritz.box>
 <20200305151530.GJ5416@oc0525413822.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@fr.ibm.com>
Date:   Thu, 5 Mar 2020 16:36:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305151530.GJ5416@oc0525413822.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030515-0016-0000-0000-000002ED8157
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030515-0017-0000-0000-00003350D5AF
Message-Id: <e4bb44b1-2bf6-6488-0a4d-ed95ac944e71@fr.ibm.com>
Subject: RE: [RFC PATCH v1] powerpc/prom_init: disable XIVE in Secure VM.
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-05_05:2020-03-05,2020-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=949 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003050100
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 3/5/20 4:15 PM, Ram Pai wrote:
> On Thu, Mar 05, 2020 at 10:55:45AM +1100, David Gibson wrote:
>> On Wed, Mar 04, 2020 at 04:56:09PM +0100, Cédric Le Goater wrote:
>>> [ ... ]
>>>
>>>> (1) applied the patch which shares the EQ-page with the hypervisor.
>>>> (2) set "kernel_irqchip=off"
>>>> (3) set "ic-mode=xive"
>>>
>>> you don't have to set the interrupt mode. xive should be negotiated
>>> by default.
>>>
>>>> (4) set "svm=on" on the kernel command line.
>>>> (5) no changes to the hypervisor and ultravisor.
>>>>
>>>> And Boom it works!.   So you were right.
>>>
>>> Excellent.
>>>  
>>>> I am sending out the patch for (1) above ASAP.
>>>
>>> Next step, could you please try to do the same with the TIMA and ESB pfn ?
>>> and use KVM.
>>
>> I'm a bit confused by this.  Aren't the TIMA and ESB pages essentially
>> IO pages, rather than memory pages from the guest's point of view?  I
>> assume only memory pages are protected with PEF - I can't even really
>> see what protecting an IO page would even mean.
> 
> It means, that the hypervisor and qemu cannot access the addresses used
> to access the I/O pages. It can only be accessed by Ultravisor and the
> SVM.
> 
> As it stands today, those pages are accessible from the hypervisor
> and not from the SVM or the ultravisor.
> 
> To make it work, we need to enable acccess to those pages from the SVM
> and from the ultravisor.  One thing I am not clear is should we block
> access to those pages from the hypervisor. If yes, than there is no> good way to do that, without hardware help.  If no, than those GPA pages
> can be shared, so that hypervisor/ultravisor/qemu/SVM can all access
> those pages.

They are shared.

KVM will also access them, at interrupt creation, device reset and 
passthrough. QEMU will use them to mask on/off the interrupts in
case of guest migration or machine stop/continue. 

C.

